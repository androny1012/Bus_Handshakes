# Bus_Handshakes

    总线握手场景描述：
    a) 总线master发出data信号，同时master用valid信号拉高表示data有效；
    b) 总线slave发出ready信号，ready信号拉高表示slave可以接收数据；
    c) 当valid和slave同时为高时，表示data信号从master到slave发送接收成功。

## 总线握手打拍实现要求：
    1) 实现上述总线同步握手场景，不考虑异步场景；
    2) 假定master的valid信号不满足时序要求，要对valid信号用寄存器打一拍，实现该总线握手场景；
    3) 假定slave的ready信号不满足时序要求，要对ready信号用寄存器打一拍，实现该总线握手场景；
    4) 假定valid和ready信号都不满足时序要求，都需要用寄存器打一拍，实现该总线握手场景。

    握手是要解决什么问题，是在什么场景用到？

## 解决方案

### 不打拍
    1)透传，搭建tb框架

### Valid打拍
    2)当对valid进行打拍后，master会产生的valid和ready能实现同步
      当bridge直接用打拍后的valid会出现valid和ready对不上的情况

      data应该用打拍前的valid还是打拍后的，打拍后的怎么用……
      
      原实现：
        valid_pre_i_r <= valid_pre_i && ready_pre_o
        ready_pre_o    = ready_post_i

        前级握手后才能送入数据
        给前级是ready直接透传
    
    在valid打拍后，slave看到的valid晚一个周期，那就可能出现后级miss了not valid，也就是握了不该握的手，因此可以只在前级握手时往后传valid

      提升吞吐率：
        valid_pre_i_r <= valid_pre_i
        ready_pre_o    = !valid_post_o | ready_post_i;

    为了提升吞吐率，我们可以利用上这个多余的握手，如果多余的握手传的是下一个准备好的数据，那不就能提升吞吐率

    因为目前的结果是slave会多握手一次，处理方式就是让master也多握手一次
    在产生给master的ready时，不仅传递slave的ready，并且加上!valid_post_o，当本级没有valid的数据时，就是master可以发数据的时机，这种情况下，尽管slave还没ready，但matser中的数据已经放在了寄存器中，只要后级ready就可以往后送，而且送的数据相比之前是额外送的，因为本级的valid和后级的valid并没有delay


    上面的描述不太准确，重述一下：
        直接打拍，分析会出现的问题：两边握手信号对不上，后级以为valid的时候，前级已经invalid了
        ready_pre_o    = ready_post_i;
        valid_pre_i_r <= valid_pre_i ;
        data_r        <= data_pre_i  ;
        
        因此，只在前级握手成功时打拍valid，保证后级收到的valid能对上
        ready_pre_o    = ready_post_i;
        valid_pre_i_r <= handshake ? valid_pre_i : valid_pre_i_r;
        data_r        <= handshake ? data_pre_i  : data_r;

        这里可以进行逻辑简化，并非前级握手打拍valid
        而是输出到前级ready为高就可以传valid，因为如果当前寄存器中有数，就会和后级发生握手，直接把当前寄存器中的数送出去(已经在寄存器中的数送出不需要cycle)，然后把前级的数打拍送入
        ready_pre_o    = ready_post_i;
        valid_pre_i_r <= ready_pre_o ? valid_pre_i : valid_pre_i_r;
        data_r        <= ready_pre_o ? data_pre_i  : data_r;

        上述情况没有考虑寄存器中没有数的情况，对应的条件是!valid_post_o，因此条件可变为
        ready_pre_o  = !valid_post_o | ready_post_i
        
        相当于这是个FIFO，FIFO为空，当然可以送数进来
        这个多出来的条件就是利用了深度为1的FIFO挤掉了气泡

        再深入分析FIFO的特性，再FIFO满的时候，如果同时前级valid(enq)，后级ready(deq)
        那么会发生的情况就把后级数据送出去的同时，寄存器中的数换成前级送入的数
        这个行为和深度为1的 pipeline fifo 行为一致
        
        如果所有模块都用此模块握手，由于ready没有打拍，会变成关键路径

### Ready打拍
    3)当对ready进行打拍后，slave的not ready传递会晚一个周期，因此master收到not ready时可能已经进行了一次握手传输，而slave又不能接收，需要加入buffer
      提炼出这个情况下的关键条件

      只有master错过了not ready的情况下发起了传输，才需要用buffer
      ready_miss = valid_pre_i && ready_pre_o && !ready_post_i
      valid_buf <= 1'b1

      逻辑简化
      ready_miss = ready_pre_o && !ready_post_i
      valid_buf <= valid_pre_i

      valid_buf 还需要一个清空的条件，否则会持续为高，往外送数
      只要ready_post_i为高，valid_buf下个周期一定为零
      两个情况，buf中有数，那么就会和后级握手，送数出去
               buf中没数，ready_post_i，不会发生ready_miss的情况，buf中不会有数

      本来ready是直接打拍的信号
      ready_pre_o  = ready_post_i_r
      透传 or 输出buf中的数
      valid_post_o = (valid_pre_i && ready_pre_o) | valid_buf

      但只要buf中没有数就前级可以往里送数  
      ready_pre_o  = !valid_buf
      valid_post_o = valid_pre_i | valid_buf

      一个case可以测出这个情况，ready为高的时候突然拉低一个周期，然后又拉高
      上面的条件会认为master会miss这个not ready，把数直接放buf里，但由于下个周期又拉高了，因此还是能直接透传数据，不需要buf
      即使不拉高，也能放到buf里暂存，因此只要buf中没数，就可以往里送数

### Valid和Ready打拍
    4)级联 2、3 实现的模块  同时对两个寄存器都打拍
      为了保证都是输出都是寄存器输出的，考虑级联的顺序

      3是向前级传递的ready寄存器输出
      2是向后级传递的valid寄存器输出
      应该把3接在前面，2接在后面，


### REF
- https://www.itdev.co.uk/blog/pipelining-axi-buses-registered-ready-signals