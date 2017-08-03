.text 0x00000000
start:
//初始化各种地址参数
addi $s0, $zero, 0x00001000	//按键的地址
addi $s1, $zero, 0x00001028	//颜色的地址
addi $s2, $zero, 0x00001034	//墙壁y坐标的地址
addi $s3, $zero, 0x00001044	//宽度的地址
addi $s4, $zero, 0x0000104c	//IO地址的地址
addi $s5, $zero, 128	//第一堵墙的curr_x 专用reg
addi $s6, $zero, 50		//curr_cat_x 专用reg
addi $s7, $zero, 240	//curr_cat_y 专用reg
addi $t8, $zero, 50		//next_cat_x 专用reg
addi $t9, $zero, 240	//next_cat_y 专用reg
lui $k0, 0x1		//player计数器 65536
addi $gp, $zero, 8		//wall计数器
addi $at, $zero, 0		//存活时间
addi $t1, $zero, 100	//初始化wall 1 y
sw $t1, 0($s2)		//存储第一堵墙的y

//写欢迎界面
add $t1, $zero, $zero	//用于遍历屏幕的x
add $t2, $zero, $zero	//用于遍历屏幕的y
addi $t3, $zero, 512	//屏幕长度
addi $t4, $zero, 140	//屏幕宽度 上
lw $t5, 12($s4)		//读取存储的vram地址
lw $t7, 8($s1)		//读取颜色（蓝）
estart1:
sw $t7, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
bne $t1, $t3, estart1
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, estart1

lw $v0, 16($s4)		//读取存储的picstart地址
add $t1, $zero, $zero	//用于遍历屏幕的x
addi $t4, $zero, 340	//屏幕宽度
lw $t7, 8($s1)		//读取颜色（蓝）
estart2:
lw $t7, 0($v0)		//取picstart像素
sw $t7, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
addi $v0, $v0, 1		//取下一像素
bne $t1, $t3, estart2
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, estart2

add $t1, $zero, $zero	//用于遍历屏幕的x
addi $t4, $zero, 480	//屏幕宽度
lw $t7, 8($s1)		//读取颜色（蓝）
estart3:
sw $t7, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
bne $t1, $t3, estart3
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, estart3
//写欢迎界面完成，等待回车开始游戏

judgeplay:
//回车开始,sw keyboard 双重控制
lw $t3, 0($s4)		//读取存储的sw读和LED写地址
lw $t1, 0($t3)		//读取sw输入
add $t4, $t1, $t1		//左移两位将sw与LED对齐
add $t4, $t4, $t4
sw $t4, 0($t3)		//存LED显示
lw $t2, 36($s0)		//读取sw12 回车数值
and $t2, $t1, $t2		//sw12=1的掩码
bne $t2, $zero, wbackground	//if sw12 == 1, play
lw $t3, 8($s4)		//读取存储的keyboard地址
lw $t1, 0($t3)		//读取keyboard输入
lw $t2, 16($s0)		//读取kbenter 回车数值
beq $t1, $t2, wbackground	//if kbkey == enter, play
j judgeplay

wbackground:
//写背景大色块
add $t1, $zero, $zero	//用于遍历屏幕的x
add $t2, $zero, $zero	//用于遍历屏幕的y
addi $t3, $zero, 512	//屏幕长度
addi $t4, $zero, 480	//屏幕宽度
lw $t5, 12($s4)		//读取存储的vram地址
lw $t7, 8($s1)		//读取颜色（蓝）
wbg:
sw $t7, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
bne $t1, $t3, wbg
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, wbg
//写背景完成，正式开始游戏

play:
//读取sw或keyboard输入上下左右
addi $k0, $k0, -1		//读取sw或键盘延迟
bne $k0, $zero, play
lui $k0, 0x1		//player计数器 65536
//读取sw
lw $t3, 0($s4)		//读取存储的sw读和LED写地址
lw $t1, 0($t3)		//读取sw输入
add $t4, $t1, $t1		//左移两位将sw与LED对齐
add $t4, $t4, $t4
sw $t4, 0($t3)		//存LED显示
lw $t2, 20($s0)		//读取sw11 上的掩码
and $t2, $t1, $t2		//sw12=1的掩码
bne $t2, $zero, up		//if sw12 == 1, play
lw $t2, 24($s0)		//读取sw10 上的掩码
and $t2, $t1, $t2		//sw12=1的掩码
bne $t2, $zero, down	//if sw12 == 1, play
lw $t2, 28($s0)		//读取sw9 上的掩码
and $t2, $t1, $t2		//sw12=1的掩码
bne $t2, $zero, left	//if sw12 == 1, play
lw $t2, 32($s0)		//读取sw8 上的掩码
and $t2, $t1, $t2		//sw12=1的掩码
bne $t2, $zero, right	//if sw12 == 1, play
//读取keyboard
lw $t3, 8($s4)		//读取存储的keyboard地址
lw $t1, 0($t3)		//读取keyboard输入
lw $t2, 0($s0)		//读取kbenter 上数值
beq $t1, $t2, up		//if kbkey == up, up
lw $t2, 4($s0)		//读取kbenter 下数值
beq $t1, $t2, down		//if kbkey == down, down
lw $t2, 8($s0)		//读取kbenter 左数值
beq $t1, $t2, left		//if kbkey == left, left
lw $t2, 12($s0)		//读取kbenter 右数值
beq $t1, $t2, right		//if kbkey == right, right
addi $t9, $t9, 3		//重力向下移动
j judgeplayer

up:
addi $t9, $t9, -3		//向上移动
j judgeplayer
down:
addi $t9, $t9, 3		//向下移动
addi $t9, $t9, 3		//重力向下移动
j judgeplayer
left:
addi $t8, $t8, -3		//向左移动
addi $t9, $t9, 3		//重力向下移动
j judgeplayer
right:
addi $t8, $t8, 3		//向右移动
addi $t9, $t9, 3		//重力向下移动
j judgeplayer

judgeplayer:
//判断next player是否出屏幕
lw $t0, 0($s3)		//读取player size
addi $t3, $zero, 512	//屏幕x-player size
addi $t4, $zero, 480	//屏幕y-player size
sub $t3, $t3, $t0
sub $t4, $t4, $t0
slt $t1, $t8, $t3		//wether cat_x < 502
slt $t2, $t9, $t4		//wether cat_y < 470
and $t7, $t1, $t2		//比较结果暂存于t7
//判断player是否与柱子相撞
add $a2, $t0, $t0		//x方向允许宽度（player width+wall width）
lw $a3, 4($s3)		//y方向允许长度（缺口宽度-player length）
sub $a3, $a3, $t0
addi $t2, $zero, 4		//初始化墙壁个数计次
add $t3, $zero, $s5		//第一堵墙壁的x
add $t4, $zero, $s2		//放置墙壁y的首地址
add $t5, $s6, $t0		//curr player x对齐+player width
add $t6, $zero, $s7		//放置curr player y

judgenextw:
beq $t2, $zero, endjudge	//墙壁全部判断完毕
lw $a0, 0($t4)		//读取当前需要判断的墙壁y
sub $t1, $t5, $t3		//player x - wall x
slt $t1, $t1, $a2		//若x在范围内，判断y是否在范围内
addi $t2, $t2, -1		//墙壁个数计次-1
addi $t3, $t3, 128		//下一堵墙壁的x
addi $t4, $t4, 4 		//墙壁y的地址+4，指向下一堵墙壁y
beq $t1, $zero, judgenextw	//x不在范围，判断下一堵墙
sub $t1, $t6, $a0		//player y - currwall y
slt $t1, $t1, $a3 		//
and $t7, $t7, $t1		//正常则为1
bne $t2, $zero, judgenextw	//下一堵墙壁计次

endjudge:
beq $t7, $zero, start	//if cat_x >= 502 or cat_y >= 470 or crash,over

displayplayer:
addi $gp, $gp, -1		//wall计数器-1
//擦除原来player
lw $t2, 0($s3)		//player高度计次
lw $t6, 12($s4)		//读取存储的vram地址
lw $t7, 8($s1)		//读取颜色（蓝）
add $t1, $s7, $s7		//player curr_x左移九位
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $s6		//加x
add $t1, $t1, $t6		//加vram地址
eplayercol:
lw $t3, 0($s3)		//player宽度计次
add $t4, $zero, $t1
eplayerrow:
sw 	$t7, 0($t4)
addi $t4, $t4, 1
addi $t3, $t3, -1
bne $t3, $zero, eplayerrow
addi $t1, $t1, 512
addi $t2, $t2, -1
bne $t2, $zero, eplayercol

wplayer:
//更新player curr地址
add $s6, $zero, $t8
add $s7, $zero ,$t9
//写player
lw $t2, 0($s3)		//player高度计次
lw $t6, 12($s4)		//读取存储的vram地址
//lw $t7, 0($s1)		//读取颜色（红）
lw $v0, 24($s4)		//读取存储的picbird地址
add $t1, $s7, $s7		//player curr_x左移九位
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $s6		//加x
add $t1, $t1, $t6		//加vram地址
wplayercol:
lw $t3, 0($s3)		//player宽度计次
add $t4, $zero, $t1
wplayerrow:
lw $t7, 0($v0)
sw 	$t7, 0($t4)
addi $v0, $v0, 1		//picbird下一像素
addi $t4, $t4, 1
addi $t3, $t3, -1
bne $t3, $zero, wplayerrow
addi $t1, $t1, 512
addi $t2, $t2, -1
bne $t2, $zero, wplayercol

wall:
bne $gp, $zero, play	//test
addi $gp, $zero, 8		//wall显示计数
addi $at, $at, 1		//存活时间+1
//擦除所有墙壁
addi $t3, $zero, 480	//墙壁高度计次
lw $t7, 8($s1)		//读取颜色（蓝）
lw $t1, 12($s4)		//vram地址
add $t1, $t1, $s5		//+第一堵墙x
enextrow:
addi $t4, $zero, 4		//墙壁个数计次
add $t2, $zero, $t1
enextwall:
lw $t0, 0($s3)		//读取player size计次
add $t5, $zero, $t2
esize:
sw $t7, 0($t5)
addi $t5, $t5, 1		//player size中下一个像素
addi $t0, $t0, -1
bne $t0, $zero, esize
addi $t2, $t2, 128		//下一个墙壁的x
addi $t4, $t4, -1		//擦除下一个墙壁
bne $t4, $zero, enextwall
addi $t1, $t1, 512		//下一行
addi $t3, $t3, -1		//擦除下一行
bne $t3, $zero, enextrow	//宽度未擦完则擦除下一行

//第一堵墙x向左移动
addi $s5, $s5, -10
addi $t1, $zero, 480
slt $t1, $s5, $t1		//if x < 480, 置为1
bne $t1, $zero, wwall	//if x < 480, 写入新墙, 否则以y1为种子，产生一个新的y4
addi $s5, $zero, 128	//复原第一堵墙x
//更新四堵墙壁y
lw $t2, 0($s2)		//读取第一堵墙的y
lw $t1, 4($s2)		//顺序更新1,2,3堵墙的y
sw $t1, 0($s2)
lw $t1, 8($s2)
sw $t1, 4($s2)
lw $t1, 12($s2)
sw $t1, 8($s2)
add $t1, $t2, $t2		//原先第一堵墙的y左移一位
addi $t1, $t1, 88		//随便选的数字
andi $t1, $t1, 399		//and掩码，防止越界
sw $t1, 12($s2)		//新y存入y4

wwall:
//写所有墙壁
addi $t3, $zero, 480	//墙壁高度计次
lw $t1, 12($s4)		//vram地址
lw $v0, 20($s4)		//读取存储的picwall地址
add $t1, $t1, $s5		//+第一堵墙x
wnextrow:
addi $t4, $zero, 4		//墙壁个数计次
add $t2, $zero, $t1
wnextwall:
lw $t0, 0($s3)		//读取player size计次
add $t5, $zero, $t2
wsize:
lw $t7, 0($v0)		//读取picwall
sw $t7, 0($t5)
addi $t5, $t5, 1		//player size中下一个像素
addi $v0, $v0, 1		//picwall中下一个像素
addi $t0, $t0, -1
bne $t0, $zero, wsize
addi $t2, $t2, 128		//下一个墙壁的x
addi $v0, $v0, -20		//回退player size （！固定）
addi $t4, $t4, -1		//擦除下一个墙壁
bne $t4, $zero, wnextwall
addi $t1, $t1, 512		//下一行
addi $t3, $t3, -1		//擦除下一行
bne $t3, $zero, wnextrow	//宽度未擦完则擦除下一行

//擦除四个墙壁缺口
lw $t6, 12($s4)		//读取存储的vram地址
lw $t7, 8($s1)		//读取颜色（蓝）
addi $t4, $zero, 4		//墙壁个数计次
add $t3, $zero, $s5		//第一堵墙x
add $t2, $zero, $s2		//存储y的首地址
eopenings:
lw $t5, 4($s3)		//缺口的宽度计次
lw $t1, 0($t2)		//顺序读取墙的y
add $t1, $t1, $t1		//y左移九位
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t3		//加x
add $t1, $t1, $t6		//加vram地址
eopenrow:
lw $t0, 0($s3)		//读取player size计次
add $k1, $zero, $t1
eopensize:
sw $t7, 0($k1)
addi $k1, $k1, 1
addi $t0, $t0, -1
bne $t0, $zero, eopensize
addi $t1, $t1, 512
addi $t5, $t5, -1
bne $t5, $zero, eopenrow
addi $t2, $t2, 4		//下一堵墙的y的地址
addi $t3, $t3, 128		//下一堵墙的x
addi $t4, $t4, -1		//墙壁个数计次-1
bne $t4, $zero, eopenings

live:
lw $t3, 4($s4)		//读取存储的seg7地址
sw $at, 0($t3)		//seg7显示玩家存活时间

j play


.data 0x00001000		//d4096
//s0
kbup: 	.word 629	//h275上
kbdown:	.word 626	//h272下
kbleft:	.word 619	//h26b左
kbright:	.word 628	//h274右
kbenter:	.word 90	//h5a 回车
swup:	.word 2048	//sw11 上
swdown:	.word 1024	//sw10 下
swleft:	.word 512	//sw9 左
swright:	.word 256	//sw8 右
swenter:	.word 4096	//sw12 回车

//s1
red:	.word 0x00f	//h00f红色
green:	.word 0x3b7	//绿色
blue:	.word 0xcc4	//蓝色背景

//s2
wall_y1:	.word 100
wall_y2:	.word 400
wall_y3:	.word 300
wall_y4:	.word 200

//s3
playerlen:	.word 20	//玩家的长宽
openinglen:	.word 80	//缺口的宽度

//s4
LEDcounter:	.word 0xf0000000	//f0000000地址 LED和硬件countersw 地址
seg7:	.word 0xe0000000	//e0000000地址 七段显示器
keyborad:	.word 0xd0000000	//d0000000地址 keyboard
vram:	.word 0xc0000000	//c0000000地址 vram
picstart:	.word 0xb0000000	//b0000000地址 picstart
picwall:	.word 0xa0000000	//a0000000地址 picwall
picbird:	.word 0x90000000	//90000000地址 picbird
