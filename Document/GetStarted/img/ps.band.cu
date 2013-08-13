%!PS-Adobe-2.0 generated by plsub.f ...
/inch{72 mul}def /cm{72 mul 2.54 div}def 0 0 translate  1 1 scale
/tails 0.4 def % set to 0 for blanking chars without tails
/lto{lineto}def % shorthand for lineto
/blank-on{/b 1 def}def /blank-off{/b 0 def}def blank-on
/smaller 0.67 def % sub/superscripts are this much smaller
/shift   0.33 def % and are shifted by this much of the char height
/hshift  0.10 def % horizontal space, fraction of char height
% push size then font onto stack to select font
/choosefont {findfont exch scalefont setfont} def
% paint object on top of stack at current position
/debug {dup /str 30 string def str cvs show} def
% finding width of longest ordinate label (current width on stack) ...
/max 0 def /mxw{/w exch def w max gt {/max w def} if}def
% string centring, justification in the four quadrants
% and absicca and ordinate label centring ...
/showru{show}def
/showcu{dup stringwidth pop 2 div neg 0 rmoveto show}def
/showlu{dup stringwidth pop neg 0 rmoveto show}def
/showrc{0 h 2 div neg rmoveto show}def
/showcc{dup stringwidth pop 2 div neg h 2 div neg rmoveto show}def
/showlc{dup stringwidth pop neg h 2 div neg rmoveto show}def
/showrd{0 h neg rmoveto show}def
/showld{dup stringwidth pop neg h neg rmoveto show}def
/showcd{dup stringwidth pop 2 div neg h neg rmoveto show}def
/showa{gsave fontsize /Symbol choosefont
       dup stringwidth pop 2 div neg h 1.5 mul neg rmoveto show grestore}def
/showA{gsave fontsize /Symbol choosefont
       dup stringwidth pop 2 div neg h 0.5 mul rmoveto show grestore}def
/showo{gsave fontsize /Symbol choosefont
       dup stringwidth pop dup mxw h 2 div add neg h 2 div neg rmoveto show grestore}def
/showO{gsave fontsize /Symbol choosefont
       dup h 2 div h 2 div neg rmoveto show grestore}def
% aliases for pslabl ...
/show0{showcc}def /show1{show}def /show2{showrd}def /show3{showld}def
/show4{showlu}def
% newline macros for horizontal and vertical labelling ...
/newlinehf{currentpoint fontsize sub moveto}def
/newlinevf{currentpoint exch fontsize add exch moveto}def
/newlinehr{currentpoint fontsize add moveto}def
/newlinevr{currentpoint exch fontsize sub exch moveto}def
/savecurrentpoint {currentpoint /ybak exch def /xbak exch def} def
% end preamble ...

 % FONT: set font and fontsize ..
/font /Times-Roman def /fontsize  24 def
/h fontsize 0.6 mul def % h is about char height
fontsize font choosefont
% pltsts:  set  logx=F  logy=F
% pltstp: frame corners (GU): lb= (0 0)  rt = (.464 1)
  1.5 setlinewidth 1 setlinejoin [7.2 3.6 2.16 3.6] 0 setdash
% --- FRME : axes at x=0 1  y=-15 15  bold=3
/max 0 def 
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
newpath 144 144 moveto 327.7 144 lto
 327.7 540 lto
 144 540 lto
 144 144 lto closepath gsave 1 1 1 setrgbcolor fill grestore stroke
newpath 144 144 moveto 144 153.9 lto stroke
newpath 162.4 144 moveto 162.4 149.9 lto stroke
newpath 180.7 144 moveto 180.7 153.9 lto stroke
newpath 199.1 144 moveto 199.1 149.9 lto stroke
newpath 217.5 144 moveto 217.5 153.9 lto stroke
newpath 235.9 144 moveto 235.9 149.9 lto stroke
newpath 254.2 144 moveto 254.2 153.9 lto stroke
newpath 272.6 144 moveto 272.6 149.9 lto stroke
newpath 291 144 moveto 291 153.9 lto stroke
newpath 309.4 144 moveto 309.4 149.9 lto stroke
newpath 327.7 144 moveto 327.7 153.9 lto stroke
newpath 144 540 moveto 144 530.1 lto stroke
newpath 162.4 540 moveto 162.4 534.1 lto stroke
newpath 180.7 540 moveto 180.7 530.1 lto stroke
newpath 199.1 540 moveto 199.1 534.1 lto stroke
newpath 217.5 540 moveto 217.5 530.1 lto stroke
newpath 235.9 540 moveto 235.9 534.1 lto stroke
newpath 254.2 540 moveto 254.2 530.1 lto stroke
newpath 272.6 540 moveto 272.6 534.1 lto stroke
newpath 291 540 moveto 291 530.1 lto stroke
newpath 309.4 540 moveto 309.4 534.1 lto stroke
newpath 327.7 540 moveto 327.7 530.1 lto stroke
newpath 144 157.2 moveto 146.8 157.2 lto stroke
newpath 144 183.6 moveto 148.6 183.6 lto stroke
gsave blank-on    144.0   183.6 moveto (-12) showo  grestore
newpath 144 210 moveto 146.8 210 lto stroke
newpath 144 236.4 moveto 148.6 236.4 lto stroke
gsave blank-on    144.0   236.4 moveto (-8) showo  grestore
newpath 144 262.8 moveto 146.8 262.8 lto stroke
newpath 144 289.2 moveto 148.6 289.2 lto stroke
gsave blank-on    144.0   289.2 moveto (-4) showo  grestore
newpath 144 315.6 moveto 146.8 315.6 lto stroke
newpath 144 342 moveto 148.6 342 lto stroke
gsave blank-on    144.0   342.0 moveto (0) showo  grestore
newpath 144 368.4 moveto 146.8 368.4 lto stroke
newpath 144 394.8 moveto 148.6 394.8 lto stroke
gsave blank-on    144.0   394.8 moveto (4) showo  grestore
newpath 144 421.2 moveto 146.8 421.2 lto stroke
newpath 144 447.6 moveto 148.6 447.6 lto stroke
gsave blank-on    144.0   447.6 moveto (8) showo  grestore
newpath 144 474 moveto 146.8 474 lto stroke
newpath 144 500.4 moveto 148.6 500.4 lto stroke
gsave blank-on    144.0   500.4 moveto (12) showo  grestore
newpath 144 526.8 moveto 146.8 526.8 lto stroke
newpath 327.7 157.2 moveto 325 157.2 lto stroke
newpath 327.7 183.6 moveto 323.2 183.6 lto stroke
newpath 327.7 210 moveto 325 210 lto stroke
newpath 327.7 236.4 moveto 323.2 236.4 lto stroke
newpath 327.7 262.8 moveto 325 262.8 lto stroke
newpath 327.7 289.2 moveto 323.2 289.2 lto stroke
newpath 327.7 315.6 moveto 325 315.6 lto stroke
newpath 327.7 342 moveto 323.2 342 lto stroke
newpath 327.7 368.4 moveto 325 368.4 lto stroke
newpath 327.7 394.8 moveto 323.2 394.8 lto stroke
newpath 327.7 421.2 moveto 325 421.2 lto stroke
newpath 327.7 447.6 moveto 323.2 447.6 lto stroke
newpath 327.7 474 moveto 325 474 lto stroke
newpath 327.7 500.4 moveto 323.2 500.4 lto stroke
newpath 327.7 526.8 moveto 325 526.8 lto stroke
  1.5 setlinewidth 1 setlinejoin [7.2 3.6 2.16 3.6] 0 setdash
% ---  xt1=0 tsx=.1 mtx=2  yt1=-14 tsy=2 mty=2
 % FRME: Label axes ...
   235.9   144.0 moveto 0 h 3 mul neg rmoveto
   144.0   342.0 moveto h 2 mul max add neg 0 rmoveto
 % FRME: adding title ...
   327.7   540.0 moveto 0 h 0.5 mul rmoveto
% --- plcrv: new curve, 2 pts lt 2 bold 3 col= 0 0 0 len=(7.2 3.6 2.16 3.6) ---
gsave newpath 144 144 moveto 144 540 lineto
              327.7 540 lineto 327.7 144 lineto closepath clip
 0 0 0 setrgbcolor
newpath 144 342 moveto 327.7 342 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 144 144 moveto 144 540 lineto
              327.7 540 lineto 327.7 144 lineto closepath clip
newpath 144 270.9 moveto 153.2 270.7 lto
    162.4    270.2 lto
    171.6    269.1 lto
    180.7    267.5 lto
    189.9    265.0 lto
    199.1    261.6 lto
    208.3    257.3 lto
    217.5    252.5 lto
    226.7    247.4 lto
    235.9    242.3 lto
    245.1    237.4 lto
    254.2    232.7 lto
    263.4    228.5 lto
    272.6    224.8 lto
    281.8    221.6 lto
    291.0    218.9 lto
    300.2    216.8 lto
    309.4    215.3 lto
    318.6    214.4 lto
 327.7 214 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 144 144 moveto 144 540 lineto
              327.7 540 lineto 327.7 144 lineto closepath clip
newpath 144 298.2 moveto 153.2 298.3 lto
    162.4    298.4 lto
    171.6    298.6 lto
    180.7    298.8 lto
    189.9    299.2 lto
    199.1    299.5 lto
    208.3    297.8 lto
    217.5    296.2 lto
    226.7    295.5 lto
    235.9    295.2 lto
    245.1    295.3 lto
    254.2    295.6 lto
    263.4    296.1 lto
    272.6    296.6 lto
    281.8    297.1 lto
    291.0    297.6 lto
    300.2    298.1 lto
    309.4    298.4 lto
    318.6    298.6 lto
 327.7 298.7 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 144 144 moveto 144 540 lineto
              327.7 540 lineto 327.7 144 lineto closepath clip
newpath 144 298.2 moveto 153.2 298.3 lto
    162.4    298.4 lto
    171.6    298.6 lto
    180.7    298.8 lto
    189.9    299.2 lto
    199.1    299.5 lto
    208.3    299.9 lto
    217.5    300.2 lto
    226.7    300.6 lto
    235.9    300.8 lto
    245.1    300.9 lto
    254.2    300.8 lto
    263.4    300.6 lto
    272.6    300.3 lto
    281.8    299.9 lto
    291.0    299.5 lto
    300.2    299.2 lto
    309.4    298.9 lto
    318.6    298.7 lto
 327.7 298.7 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 144 144 moveto 144 540 lineto
              327.7 540 lineto 327.7 144 lineto closepath clip
newpath 144 317.6 moveto 153.2 317.5 lto
    162.4    317.2 lto
    171.6    314.3 lto
    180.7    308.9 lto
    189.9    304.1 lto
    199.1    300.4 lto
    208.3    299.9 lto
    217.5    300.2 lto
    226.7    300.6 lto
    235.9    300.8 lto
    245.1    300.9 lto
    254.2    300.8 lto
    263.4    300.6 lto
    272.6    300.3 lto
    281.8    299.9 lto
    291.0    299.5 lto
    300.2    299.2 lto
    309.4    298.9 lto
    318.6    298.7 lto
 327.7 298.7 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 144 144 moveto 144 540 lineto
              327.7 540 lineto 327.7 144 lineto closepath clip
newpath 144 317.6 moveto 153.2 317.5 lto
    162.4    317.2 lto
    171.6    316.8 lto
    180.7    316.1 lto
    189.9    315.4 lto
    199.1    314.5 lto
    208.3    313.6 lto
    217.5    312.7 lto
    226.7    311.8 lto
    235.9    311.0 lto
    245.1    310.4 lto
    254.2    309.9 lto
    263.4    309.6 lto
    272.6    309.5 lto
    281.8    309.5 lto
    291.0    309.6 lto
    300.2    309.7 lto
    309.4    309.8 lto
    318.6    309.9 lto
 327.7 309.9 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 144 144 moveto 144 540 lineto
              327.7 540 lineto 327.7 144 lineto closepath clip
newpath 144 325.3 moveto 153.2 323.7 lto
    162.4    319.6 lto
    171.6    316.8 lto
    180.7    316.1 lto
    189.9    315.4 lto
    199.1    314.5 lto
    208.3    313.6 lto
    217.5    312.7 lto
    226.7    311.8 lto
    235.9    311.0 lto
    245.1    310.4 lto
    254.2    309.9 lto
    263.4    309.6 lto
    272.6    309.5 lto
    281.8    309.5 lto
    291.0    309.6 lto
    300.2    309.7 lto
    309.4    309.8 lto
    318.6    309.9 lto
 327.7 309.9 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 144 144 moveto 144 540 lineto
              327.7 540 lineto 327.7 144 lineto closepath clip
newpath 144 389.7 moveto 153.2 392.1 lto
    162.4    398.4 lto
    171.6    407.7 lto
    180.7    418.8 lto
    189.9    431.3 lto
    199.1    444.7 lto
    208.3    458.9 lto
    217.5    473.8 lto
    226.7    489.3 lto
    235.9    505.2 lto
    245.1    521.6 lto
    254.2    538.3 lto
    263.4    555.4 lto
    272.6    572.6 lto
    281.8    589.9 lto
    291.0    606.7 lto
    300.2    622.1 lto
    309.4    633.3 lto
    318.6    638.6 lto
 327.7 639.8 lto

 stroke grestore
% pltsts:  set  logx=F  logy=F
% pltstp: frame corners (GU): lb= (.464 0)  rt = (1 1)
  1.5 setlinewidth 1 setlinejoin [7.2 3.6 2.16 3.6] 0 setdash
% --- FRME : axes at x=0 1  y=-15 15  bold=3
/max 0 def 
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
newpath 327.7 144 moveto 540 144 lto
 540 540 lto
 327.7 540 lto
 327.7 144 lto closepath gsave 1 1 1 setrgbcolor fill grestore stroke
newpath 327.7 144 moveto 327.7 153.9 lto stroke
newpath 349 144 moveto 349 149.9 lto stroke
newpath 370.2 144 moveto 370.2 153.9 lto stroke
newpath 391.4 144 moveto 391.4 149.9 lto stroke
newpath 412.6 144 moveto 412.6 153.9 lto stroke
newpath 433.9 144 moveto 433.9 149.9 lto stroke
newpath 455.1 144 moveto 455.1 153.9 lto stroke
newpath 476.3 144 moveto 476.3 149.9 lto stroke
newpath 497.5 144 moveto 497.5 153.9 lto stroke
newpath 518.8 144 moveto 518.8 149.9 lto stroke
newpath 540 144 moveto 540 153.9 lto stroke
newpath 327.7 540 moveto 327.7 530.1 lto stroke
newpath 349 540 moveto 349 534.1 lto stroke
newpath 370.2 540 moveto 370.2 530.1 lto stroke
newpath 391.4 540 moveto 391.4 534.1 lto stroke
newpath 412.6 540 moveto 412.6 530.1 lto stroke
newpath 433.9 540 moveto 433.9 534.1 lto stroke
newpath 455.1 540 moveto 455.1 530.1 lto stroke
newpath 476.3 540 moveto 476.3 534.1 lto stroke
newpath 497.5 540 moveto 497.5 530.1 lto stroke
newpath 518.8 540 moveto 518.8 534.1 lto stroke
newpath 540 540 moveto 540 530.1 lto stroke
newpath 327.7 157.2 moveto 330.9 157.2 lto stroke
newpath 327.7 183.6 moveto 333.1 183.6 lto stroke
newpath 327.7 210 moveto 330.9 210 lto stroke
newpath 327.7 236.4 moveto 333.1 236.4 lto stroke
newpath 327.7 262.8 moveto 330.9 262.8 lto stroke
newpath 327.7 289.2 moveto 333.1 289.2 lto stroke
newpath 327.7 315.6 moveto 330.9 315.6 lto stroke
newpath 327.7 342 moveto 333.1 342 lto stroke
newpath 327.7 368.4 moveto 330.9 368.4 lto stroke
newpath 327.7 394.8 moveto 333.1 394.8 lto stroke
newpath 327.7 421.2 moveto 330.9 421.2 lto stroke
newpath 327.7 447.6 moveto 333.1 447.6 lto stroke
newpath 327.7 474 moveto 330.9 474 lto stroke
newpath 327.7 500.4 moveto 333.1 500.4 lto stroke
newpath 327.7 526.8 moveto 330.9 526.8 lto stroke
newpath 540 157.2 moveto 536.8 157.2 lto stroke
newpath 540 183.6 moveto 534.7 183.6 lto stroke
newpath 540 210 moveto 536.8 210 lto stroke
newpath 540 236.4 moveto 534.7 236.4 lto stroke
newpath 540 262.8 moveto 536.8 262.8 lto stroke
newpath 540 289.2 moveto 534.7 289.2 lto stroke
newpath 540 315.6 moveto 536.8 315.6 lto stroke
newpath 540 342 moveto 534.7 342 lto stroke
newpath 540 368.4 moveto 536.8 368.4 lto stroke
newpath 540 394.8 moveto 534.7 394.8 lto stroke
newpath 540 421.2 moveto 536.8 421.2 lto stroke
newpath 540 447.6 moveto 534.7 447.6 lto stroke
newpath 540 474 moveto 536.8 474 lto stroke
newpath 540 500.4 moveto 534.7 500.4 lto stroke
newpath 540 526.8 moveto 536.8 526.8 lto stroke
  1.5 setlinewidth 1 setlinejoin [7.2 3.6 2.16 3.6] 0 setdash
% ---  xt1=0 tsx=.1 mtx=2  yt1=-14 tsy=2 mty=2
 % FRME: Label axes ...
   433.9   144.0 moveto 0 h 3 mul neg rmoveto
   327.7   342.0 moveto h 2 mul max add neg 0 rmoveto
 % FRME: adding title ...
   540.0   540.0 moveto 0 h 0.5 mul rmoveto
% --- plcrv: new curve, 2 pts lt 2 bold 3 col= 0 0 0 len=(7.2 3.6 2.16 3.6) ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
 0 0 0 setrgbcolor
newpath 327.7 342 moveto 540 342 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 214 moveto 338.4 214.4 lto
    349.0    215.7 lto
    359.6    217.7 lto
    370.2    220.5 lto
    380.8    224.0 lto
    391.4    228.3 lto
    402.0    233.2 lto
    412.6    238.7 lto
    423.3    244.7 lto
    433.9    250.8 lto
    444.5    256.9 lto
    455.1    262.5 lto
    465.7    267.0 lto
    476.3    270.1 lto
    486.9    272.0 lto
    497.5    273.0 lto
    508.2    273.4 lto
    518.8    273.5 lto
    529.4    273.6 lto
 540 273.6 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 298.7 moveto 338.4 298.5 lto
    349.0    298.1 lto
    359.6    297.6 lto
    370.2    296.7 lto
    380.8    295.7 lto
    391.4    294.6 lto
    402.0    293.2 lto
    412.6    291.8 lto
    423.3    290.4 lto
    433.9    288.9 lto
    444.5    287.4 lto
    455.1    286.0 lto
    465.7    284.7 lto
    476.3    283.4 lto
    486.9    282.3 lto
    497.5    281.4 lto
    508.2    280.7 lto
    518.8    280.1 lto
    529.4    279.8 lto
 540 279.7 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 298.7 moveto 338.4 298.7 lto
    349.0    299.0 lto
    359.6    299.5 lto
    370.2    300.2 lto
    380.8    301.1 lto
    391.4    302.1 lto
    402.0    303.3 lto
    412.6    304.5 lto
    423.3    303.8 lto
    433.9    303.6 lto
    444.5    304.2 lto
    455.1    306.1 lto
    465.7    309.6 lto
    476.3    314.2 lto
    486.9    315.6 lto
    497.5    316.7 lto
    508.2    317.0 lto
    518.8    317.2 lto
    529.4    317.4 lto
 540 317.4 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 298.7 moveto 338.4 298.7 lto
    349.0    299.0 lto
    359.6    299.5 lto
    370.2    300.2 lto
    380.8    301.1 lto
    391.4    302.1 lto
    402.0    303.3 lto
    412.6    304.6 lto
    423.3    306.1 lto
    433.9    307.6 lto
    444.5    309.3 lto
    455.1    310.9 lto
    465.7    312.6 lto
    476.3    314.2 lto
    486.9    315.6 lto
    497.5    317.0 lto
    508.2    318.0 lto
    518.8    318.9 lto
    529.4    319.4 lto
 540 319.6 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 309.9 moveto 338.4 309.8 lto
    349.0    309.5 lto
    359.6    308.9 lto
    370.2    308.2 lto
    380.8    307.3 lto
    391.4    306.4 lto
    402.0    305.4 lto
    412.6    304.6 lto
    423.3    306.1 lto
    433.9    307.6 lto
    444.5    309.3 lto
    455.1    310.9 lto
    465.7    312.6 lto
    476.3    315.2 lto
    486.9    316.3 lto
    497.5    317.0 lto
    508.2    318.0 lto
    518.8    318.9 lto
    529.4    319.4 lto
 540 319.6 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 309.9 moveto 338.4 309.9 lto
    349.0    310.1 lto
    359.6    310.3 lto
    370.2    310.6 lto
    380.8    311.0 lto
    391.4    311.4 lto
    402.0    311.9 lto
    412.6    312.5 lto
    423.3    313.0 lto
    433.9    313.6 lto
    444.5    314.2 lto
    455.1    314.8 lto
    465.7    315.3 lto
    476.3    315.8 lto
    486.9    322.6 lto
    497.5    331.3 lto
    508.2    340.5 lto
    518.8    349.2 lto
    529.4    356.0 lto
 540 358.6 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 639.8 moveto 338.4 638.3 lto
    349.0    634.3 lto
    359.6    628.9 lto
    370.2    622.8 lto
    380.8    616.7 lto
    391.4    610.9 lto
    402.0    599.3 lto
    412.6    588.0 lto
    423.3    577.4 lto
    433.9    567.3 lto
    444.5    557.8 lto
    455.1    546.2 lto
    465.7    527.4 lto
    476.3    509.1 lto
    486.9    491.5 lto
    497.5    475.0 lto
    508.2    459.9 lto
    518.8    447.1 lto
    529.4    438.0 lto
 540 434.5 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 676.8 moveto 338.4 671.4 lto
    349.0    660.4 lto
    359.6    648.1 lto
    370.2    635.5 lto
    380.8    623.1 lto
    391.4    611.0 lto
    402.0    599.3 lto
    412.6    588.1 lto
    423.3    577.4 lto
    433.9    567.3 lto
    444.5    557.8 lto
    455.1    549.1 lto
    465.7    541.2 lto
    476.3    534.1 lto
    486.9    527.9 lto
    497.5    522.8 lto
    508.2    518.7 lto
    518.8    515.7 lto
    529.4    513.9 lto
 540 513.3 lto

 stroke grestore
  1.5 setlinewidth 1 setlinejoin [ ] 0 setdash
% --- plcrv: new curve, 21 pts lt 1 bold 3 ---
gsave newpath 327.7 144 moveto 327.7 540 lineto
              540 540 lineto 540 144 lineto closepath clip
newpath 327.7 676.8 moveto 338.4 671.4 lto
    349.0    660.4 lto
    359.6    648.1 lto
    370.2    635.5 lto
    380.8    623.1 lto
    391.4    611.0 lto
    402.0    605.3 lto
    412.6    600.3 lto
    423.3    595.7 lto
    433.9    583.3 lto
    444.5    565.0 lto
    455.1    549.1 lto
    465.7    541.2 lto
    476.3    534.1 lto
    486.9    527.9 lto
    497.5    522.8 lto
    508.2    518.7 lto
    518.8    515.7 lto
    529.4    513.9 lto
 540 513.3 lto

 stroke grestore
%%BoundingBox: 144 144 540 676.8
showpage
