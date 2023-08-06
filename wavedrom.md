## 无打拍

    {signal: [
    {name: 'clk', wave: 'p.....|...'},
    {name: 'm_dat_i', wave: 'x.345x|6x.', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 'm_vld_i', wave: '0.1..0|10.'},
    {name: 'm_rdy_o', wave: '0.1..0|10.'},
    {},
    {name: 's_dat_o', wave: 'x.345x|6.x', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 's_vld_o', wave: '0.1..0|10.'},
    {name: 's_rdy_i', wave: '0.1..0|10.'},
    ]}

## matser valid打拍

### 会出现的错误，master以为握手了，但slave没握手

    {signal: [
    {name: 'clk'    , wave: 'p.........'},
    {name: 'm_dat_i', wave: 'x.3456.345', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 'm_vld_i', wave: '0.1.......'},
    {name: 'm_rdy_o', wave: '0.1..010..'},
    {},
    {name: 's_dat_o', wave: 'x..3456.34', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 's_vld_o', wave: '0..1......'},
    {name: 's_rdy_i', wave: '0.1..010..'},
    ]}

###  修改打拍条件，提升吞吐量

    {},
    {name: 'clk'    , wave: 'p..............'},
    {name: 'm_dat_i', wave: 'x.3456.3x4.x...', data: ['D0', 'D1', 'D2', 'D3', 'D4', 'D5']},
    {name: 'm_vld_i', wave: '0.1.....01.0...'},
    {name: 'm_rdy_o', wave: '0.1..01..01....'},
    {},
    {name: 's_dat_o', wave: 'x..345.63x.4x..', data: ['D0', 'D1', 'D2', 'D3', 'D4', 'D5']},
    {name: 's_vld_o', wave: '0..1.....0.10..'},
    {name: 's_rdy_i', wave: '0.1..01..01....'},
 
    {},
    {name: 'clk'    , wave: 'p.............'},
    {name: 'm_dat_i', wave: 'x.3456.3x4xx..', data: ['D0', 'D1', 'D2', 'D3', 'D4', 'D5']},
    {name: 'm_vld_i', wave: '0.1.....010...'},
    {name: 'm_rdy_o', wave: '0.1..01.......'},
    {},
    {name: 's_dat_o', wave: 'x..345.63x4x..', data: ['D0', 'D1', 'D2', 'D3', 'D4', 'D5']},
    {name: 's_vld_o', wave: '0..1.....010..'},
    {name: 's_rdy_i', wave: '0.1..01..01...'},
  	{},


## slave ready打拍



{signal: [
 
    {name: 'clk'    , wave: 'p.........'},
    {name: 'm_dat_i', wave: 'x.345.6...', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 'm_vld_i', wave: '0.1.......'},
    {name: 'm_rdy_o', wave: '1...010...'},
    {},
    {name: 's_dat_o', wave: 'x.345.6...', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 's_vld_o', wave: '0.1.......'},
    {name: 's_rdy_i', wave: '1...010...'},

  	{},
  	{},
  	{},
    {name: 'clk'    , wave: 'p.........'},
    {name: 'm_dat_i', wave: 'x.3456..3.', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 'm_vld_i', wave: '0.1.......'},
    {name: 'm_rdy_o', wave: '1....0.10.'},
    {},
    {name: 's_dat_o', wave: 'x.3456..3.', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 's_vld_o', wave: '0.1.......'},
    {name: 's_rdy_i', wave: '1...0.10..'},

    {},
  	{},
  	{},
    {name: 'clk'    , wave: 'p..........'},
    {name: 'm_dat_i', wave: 'x.3456..3..', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 'm_vld_i', wave: '0.1........'},
    {name: 'm_rdy_o', wave: '1....0.10..'},
    {},
    {name: 's_dat_o', wave: 'x.345..6...', data: ['D0', 'D1', 'D2', 'D3']},
    {name: 's_vld_o', wave: '0.1........'},
    {name: 's_rdy_i', wave: '1...0.10...'},

    {},
  	{},
  	{},
    {name: 'clk'    , wave: 'p...............'},
    {name: 'm_dat_i', wave: 'x.3456..x3.x....', data: ['D0', 'D1', 'D2', 'D3', 'D4']},
    {name: 'm_vld_i', wave: '0.1.....01.0....'},
    {name: 'm_rdy_o', wave: '1....0.1.010..1.'},
    {},
    {name: 's_dat_o', wave: 'x.345..6x3....x.', data: ['D0', 'D1', 'D2', 'D3', 'D4']},
    {name: 's_vld_o', wave: '0.1.....0.1...0.'},
    {name: 's_rdy_i', wave: '1...0.1.010..1..'},
    {},
  	{},
  	{},  
    {name: 'clk'    , wave: 'p...............'},
    {name: 'm_dat_i', wave: 'x.3456..x34x....', data: ['D0', 'D1', 'D2', 'D3', 'D4', 'D5']},
    {name: 'm_vld_i', wave: '0.1.....01.0....'},
    {name: 'm_rdy_o', wave: '1....0.1...0..1.'},
    {},
    {name: 's_dat_o', wave: 'x.345..6x34...x.', data: ['D0', 'D1', 'D2', 'D3', 'D4', 'D5']},
    {name: 's_vld_o', wave: '0.1.....01....0.'},
    {name: 's_rdy_i', wave: '1...0.1.010..1..'},
    {},
  	{},
  	{},  
]}
  
