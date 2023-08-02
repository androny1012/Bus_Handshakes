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
      
    3)当对ready进行打拍后，slave的not ready传递会晚一个周期，因此master收到not ready时可能已经进行了一次握手传输，而slave又不能接收，需要加入buffer
      提炼出这个情况下的关键条件
      ready_miss = valid_pre_i && ready_pre_o && !ready_post_i;
      只有master错过了not ready的情况下发起了传输，才需要用buffer

    4)级联 2、3 实现的模块  同时对两个寄存器都打拍