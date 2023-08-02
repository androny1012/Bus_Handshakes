# Bus_Handshakes


    总线握手场景描述：
    a) 总线master发出data信号，同时master用valid信号拉高表示data有效；
    b) 总线slave发出ready信号，ready信号拉高表示slave可以接收数据；
    c) 当valid和slave同时为高时，表示data信号从master到slave发送接收成功。

    总线握手打拍实现要求：
    1) 实现上述总线同步握手场景，不考虑异步场景；
    2) 假定master的valid信号不满足时序要求，要对valid信号用寄存器打一拍，实现该总线握手场景；
    3) 假定slave的ready信号不满足时序要求，要对ready信号用寄存器打一拍，实现该总线握手场景；
    4) 假定valid和ready信号都不满足时序要求，都需要用寄存器打一拍，实现该总线握手场景。

    握手是要解决什么问题，是在什么场景用到？

    1)透传，搭建tb框架
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

    3)当对ready进行打拍后，slave的not ready传递会晚一个周期，因此master收到not ready时可能已经进行了一次握手传输，而slave又不能接收，需要加入buffer
      提炼出这个情况下的关键条件
      ready_miss = valid_pre_i && ready_pre_o && !ready_post_i;
      只有master错过了not ready的情况下发起了传输，才需要用buffer

    4)级联 2、3 实现的模块  同时对两个寄存器都打拍