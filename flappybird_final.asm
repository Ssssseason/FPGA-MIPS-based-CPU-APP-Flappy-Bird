.text 0x00000000
start:
//��ʼ�����ֵ�ַ����
addi $s0, $zero, 0x00001000	//�����ĵ�ַ
addi $s1, $zero, 0x00001028	//��ɫ�ĵ�ַ
addi $s2, $zero, 0x00001034	//ǽ��y����ĵ�ַ
addi $s3, $zero, 0x00001044	//��ȵĵ�ַ
addi $s4, $zero, 0x0000104c	//IO��ַ�ĵ�ַ
addi $s5, $zero, 128	//��һ��ǽ��curr_x ר��reg
addi $s6, $zero, 50		//curr_cat_x ר��reg
addi $s7, $zero, 240	//curr_cat_y ר��reg
addi $t8, $zero, 50		//next_cat_x ר��reg
addi $t9, $zero, 240	//next_cat_y ר��reg
lui $k0, 0x1		//player������ 65536
addi $gp, $zero, 8		//wall������
addi $at, $zero, 0		//���ʱ��
addi $t1, $zero, 100	//��ʼ��wall 1 y
sw $t1, 0($s2)		//�洢��һ��ǽ��y

//д��ӭ����
add $t1, $zero, $zero	//���ڱ�����Ļ��x
add $t2, $zero, $zero	//���ڱ�����Ļ��y
addi $t3, $zero, 512	//��Ļ����
addi $t4, $zero, 140	//��Ļ��� ��
lw $t5, 12($s4)		//��ȡ�洢��vram��ַ
lw $t7, 8($s1)		//��ȡ��ɫ������
estart1:
sw $t7, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
bne $t1, $t3, estart1
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, estart1

lw $v0, 16($s4)		//��ȡ�洢��picstart��ַ
add $t1, $zero, $zero	//���ڱ�����Ļ��x
addi $t4, $zero, 340	//��Ļ���
lw $t7, 8($s1)		//��ȡ��ɫ������
estart2:
lw $t7, 0($v0)		//ȡpicstart����
sw $t7, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
addi $v0, $v0, 1		//ȡ��һ����
bne $t1, $t3, estart2
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, estart2

add $t1, $zero, $zero	//���ڱ�����Ļ��x
addi $t4, $zero, 480	//��Ļ���
lw $t7, 8($s1)		//��ȡ��ɫ������
estart3:
sw $t7, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
bne $t1, $t3, estart3
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, estart3
//д��ӭ������ɣ��ȴ��س���ʼ��Ϸ

judgeplay:
//�س���ʼ,sw keyboard ˫�ؿ���
lw $t3, 0($s4)		//��ȡ�洢��sw����LEDд��ַ
lw $t1, 0($t3)		//��ȡsw����
add $t4, $t1, $t1		//������λ��sw��LED����
add $t4, $t4, $t4
sw $t4, 0($t3)		//��LED��ʾ
lw $t2, 36($s0)		//��ȡsw12 �س���ֵ
and $t2, $t1, $t2		//sw12=1������
bne $t2, $zero, wbackground	//if sw12 == 1, play
lw $t3, 8($s4)		//��ȡ�洢��keyboard��ַ
lw $t1, 0($t3)		//��ȡkeyboard����
lw $t2, 16($s0)		//��ȡkbenter �س���ֵ
beq $t1, $t2, wbackground	//if kbkey == enter, play
j judgeplay

wbackground:
//д������ɫ��
add $t1, $zero, $zero	//���ڱ�����Ļ��x
add $t2, $zero, $zero	//���ڱ�����Ļ��y
addi $t3, $zero, 512	//��Ļ����
addi $t4, $zero, 480	//��Ļ���
lw $t5, 12($s4)		//��ȡ�洢��vram��ַ
lw $t7, 8($s1)		//��ȡ��ɫ������
wbg:
sw $t7, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
bne $t1, $t3, wbg
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, wbg
//д������ɣ���ʽ��ʼ��Ϸ

play:
//��ȡsw��keyboard������������
addi $k0, $k0, -1		//��ȡsw������ӳ�
bne $k0, $zero, play
lui $k0, 0x1		//player������ 65536
//��ȡsw
lw $t3, 0($s4)		//��ȡ�洢��sw����LEDд��ַ
lw $t1, 0($t3)		//��ȡsw����
add $t4, $t1, $t1		//������λ��sw��LED����
add $t4, $t4, $t4
sw $t4, 0($t3)		//��LED��ʾ
lw $t2, 20($s0)		//��ȡsw11 �ϵ�����
and $t2, $t1, $t2		//sw12=1������
bne $t2, $zero, up		//if sw12 == 1, play
lw $t2, 24($s0)		//��ȡsw10 �ϵ�����
and $t2, $t1, $t2		//sw12=1������
bne $t2, $zero, down	//if sw12 == 1, play
lw $t2, 28($s0)		//��ȡsw9 �ϵ�����
and $t2, $t1, $t2		//sw12=1������
bne $t2, $zero, left	//if sw12 == 1, play
lw $t2, 32($s0)		//��ȡsw8 �ϵ�����
and $t2, $t1, $t2		//sw12=1������
bne $t2, $zero, right	//if sw12 == 1, play
//��ȡkeyboard
lw $t3, 8($s4)		//��ȡ�洢��keyboard��ַ
lw $t1, 0($t3)		//��ȡkeyboard����
lw $t2, 0($s0)		//��ȡkbenter ����ֵ
beq $t1, $t2, up		//if kbkey == up, up
lw $t2, 4($s0)		//��ȡkbenter ����ֵ
beq $t1, $t2, down		//if kbkey == down, down
lw $t2, 8($s0)		//��ȡkbenter ����ֵ
beq $t1, $t2, left		//if kbkey == left, left
lw $t2, 12($s0)		//��ȡkbenter ����ֵ
beq $t1, $t2, right		//if kbkey == right, right
addi $t9, $t9, 3		//���������ƶ�
j judgeplayer

up:
addi $t9, $t9, -3		//�����ƶ�
j judgeplayer
down:
addi $t9, $t9, 3		//�����ƶ�
addi $t9, $t9, 3		//���������ƶ�
j judgeplayer
left:
addi $t8, $t8, -3		//�����ƶ�
addi $t9, $t9, 3		//���������ƶ�
j judgeplayer
right:
addi $t8, $t8, 3		//�����ƶ�
addi $t9, $t9, 3		//���������ƶ�
j judgeplayer

judgeplayer:
//�ж�next player�Ƿ����Ļ
lw $t0, 0($s3)		//��ȡplayer size
addi $t3, $zero, 512	//��Ļx-player size
addi $t4, $zero, 480	//��Ļy-player size
sub $t3, $t3, $t0
sub $t4, $t4, $t0
slt $t1, $t8, $t3		//wether cat_x < 502
slt $t2, $t9, $t4		//wether cat_y < 470
and $t7, $t1, $t2		//�ȽϽ���ݴ���t7
//�ж�player�Ƿ���������ײ
add $a2, $t0, $t0		//x���������ȣ�player width+wall width��
lw $a3, 4($s3)		//y���������ȣ�ȱ�ڿ��-player length��
sub $a3, $a3, $t0
addi $t2, $zero, 4		//��ʼ��ǽ�ڸ����ƴ�
add $t3, $zero, $s5		//��һ��ǽ�ڵ�x
add $t4, $zero, $s2		//����ǽ��y���׵�ַ
add $t5, $s6, $t0		//curr player x����+player width
add $t6, $zero, $s7		//����curr player y

judgenextw:
beq $t2, $zero, endjudge	//ǽ��ȫ���ж����
lw $a0, 0($t4)		//��ȡ��ǰ��Ҫ�жϵ�ǽ��y
sub $t1, $t5, $t3		//player x - wall x
slt $t1, $t1, $a2		//��x�ڷ�Χ�ڣ��ж�y�Ƿ��ڷ�Χ��
addi $t2, $t2, -1		//ǽ�ڸ����ƴ�-1
addi $t3, $t3, 128		//��һ��ǽ�ڵ�x
addi $t4, $t4, 4 		//ǽ��y�ĵ�ַ+4��ָ����һ��ǽ��y
beq $t1, $zero, judgenextw	//x���ڷ�Χ���ж���һ��ǽ
sub $t1, $t6, $a0		//player y - currwall y
slt $t1, $t1, $a3 		//
and $t7, $t7, $t1		//������Ϊ1
bne $t2, $zero, judgenextw	//��һ��ǽ�ڼƴ�

endjudge:
beq $t7, $zero, start	//if cat_x >= 502 or cat_y >= 470 or crash,over

displayplayer:
addi $gp, $gp, -1		//wall������-1
//����ԭ��player
lw $t2, 0($s3)		//player�߶ȼƴ�
lw $t6, 12($s4)		//��ȡ�洢��vram��ַ
lw $t7, 8($s1)		//��ȡ��ɫ������
add $t1, $s7, $s7		//player curr_x���ƾ�λ
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $s6		//��x
add $t1, $t1, $t6		//��vram��ַ
eplayercol:
lw $t3, 0($s3)		//player��ȼƴ�
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
//����player curr��ַ
add $s6, $zero, $t8
add $s7, $zero ,$t9
//дplayer
lw $t2, 0($s3)		//player�߶ȼƴ�
lw $t6, 12($s4)		//��ȡ�洢��vram��ַ
//lw $t7, 0($s1)		//��ȡ��ɫ���죩
lw $v0, 24($s4)		//��ȡ�洢��picbird��ַ
add $t1, $s7, $s7		//player curr_x���ƾ�λ
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $s6		//��x
add $t1, $t1, $t6		//��vram��ַ
wplayercol:
lw $t3, 0($s3)		//player��ȼƴ�
add $t4, $zero, $t1
wplayerrow:
lw $t7, 0($v0)
sw 	$t7, 0($t4)
addi $v0, $v0, 1		//picbird��һ����
addi $t4, $t4, 1
addi $t3, $t3, -1
bne $t3, $zero, wplayerrow
addi $t1, $t1, 512
addi $t2, $t2, -1
bne $t2, $zero, wplayercol

wall:
bne $gp, $zero, play	//test
addi $gp, $zero, 8		//wall��ʾ����
addi $at, $at, 1		//���ʱ��+1
//��������ǽ��
addi $t3, $zero, 480	//ǽ�ڸ߶ȼƴ�
lw $t7, 8($s1)		//��ȡ��ɫ������
lw $t1, 12($s4)		//vram��ַ
add $t1, $t1, $s5		//+��һ��ǽx
enextrow:
addi $t4, $zero, 4		//ǽ�ڸ����ƴ�
add $t2, $zero, $t1
enextwall:
lw $t0, 0($s3)		//��ȡplayer size�ƴ�
add $t5, $zero, $t2
esize:
sw $t7, 0($t5)
addi $t5, $t5, 1		//player size����һ������
addi $t0, $t0, -1
bne $t0, $zero, esize
addi $t2, $t2, 128		//��һ��ǽ�ڵ�x
addi $t4, $t4, -1		//������һ��ǽ��
bne $t4, $zero, enextwall
addi $t1, $t1, 512		//��һ��
addi $t3, $t3, -1		//������һ��
bne $t3, $zero, enextrow	//���δ�����������һ��

//��һ��ǽx�����ƶ�
addi $s5, $s5, -10
addi $t1, $zero, 480
slt $t1, $s5, $t1		//if x < 480, ��Ϊ1
bne $t1, $zero, wwall	//if x < 480, д����ǽ, ������y1Ϊ���ӣ�����һ���µ�y4
addi $s5, $zero, 128	//��ԭ��һ��ǽx
//�����Ķ�ǽ��y
lw $t2, 0($s2)		//��ȡ��һ��ǽ��y
lw $t1, 4($s2)		//˳�����1,2,3��ǽ��y
sw $t1, 0($s2)
lw $t1, 8($s2)
sw $t1, 4($s2)
lw $t1, 12($s2)
sw $t1, 8($s2)
add $t1, $t2, $t2		//ԭ�ȵ�һ��ǽ��y����һλ
addi $t1, $t1, 88		//���ѡ������
andi $t1, $t1, 399		//and���룬��ֹԽ��
sw $t1, 12($s2)		//��y����y4

wwall:
//д����ǽ��
addi $t3, $zero, 480	//ǽ�ڸ߶ȼƴ�
lw $t1, 12($s4)		//vram��ַ
lw $v0, 20($s4)		//��ȡ�洢��picwall��ַ
add $t1, $t1, $s5		//+��һ��ǽx
wnextrow:
addi $t4, $zero, 4		//ǽ�ڸ����ƴ�
add $t2, $zero, $t1
wnextwall:
lw $t0, 0($s3)		//��ȡplayer size�ƴ�
add $t5, $zero, $t2
wsize:
lw $t7, 0($v0)		//��ȡpicwall
sw $t7, 0($t5)
addi $t5, $t5, 1		//player size����һ������
addi $v0, $v0, 1		//picwall����һ������
addi $t0, $t0, -1
bne $t0, $zero, wsize
addi $t2, $t2, 128		//��һ��ǽ�ڵ�x
addi $v0, $v0, -20		//����player size �����̶���
addi $t4, $t4, -1		//������һ��ǽ��
bne $t4, $zero, wnextwall
addi $t1, $t1, 512		//��һ��
addi $t3, $t3, -1		//������һ��
bne $t3, $zero, wnextrow	//���δ�����������һ��

//�����ĸ�ǽ��ȱ��
lw $t6, 12($s4)		//��ȡ�洢��vram��ַ
lw $t7, 8($s1)		//��ȡ��ɫ������
addi $t4, $zero, 4		//ǽ�ڸ����ƴ�
add $t3, $zero, $s5		//��һ��ǽx
add $t2, $zero, $s2		//�洢y���׵�ַ
eopenings:
lw $t5, 4($s3)		//ȱ�ڵĿ�ȼƴ�
lw $t1, 0($t2)		//˳���ȡǽ��y
add $t1, $t1, $t1		//y���ƾ�λ
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t3		//��x
add $t1, $t1, $t6		//��vram��ַ
eopenrow:
lw $t0, 0($s3)		//��ȡplayer size�ƴ�
add $k1, $zero, $t1
eopensize:
sw $t7, 0($k1)
addi $k1, $k1, 1
addi $t0, $t0, -1
bne $t0, $zero, eopensize
addi $t1, $t1, 512
addi $t5, $t5, -1
bne $t5, $zero, eopenrow
addi $t2, $t2, 4		//��һ��ǽ��y�ĵ�ַ
addi $t3, $t3, 128		//��һ��ǽ��x
addi $t4, $t4, -1		//ǽ�ڸ����ƴ�-1
bne $t4, $zero, eopenings

live:
lw $t3, 4($s4)		//��ȡ�洢��seg7��ַ
sw $at, 0($t3)		//seg7��ʾ��Ҵ��ʱ��

j play


.data 0x00001000		//d4096
//s0
kbup: 	.word 629	//h275��
kbdown:	.word 626	//h272��
kbleft:	.word 619	//h26b��
kbright:	.word 628	//h274��
kbenter:	.word 90	//h5a �س�
swup:	.word 2048	//sw11 ��
swdown:	.word 1024	//sw10 ��
swleft:	.word 512	//sw9 ��
swright:	.word 256	//sw8 ��
swenter:	.word 4096	//sw12 �س�

//s1
red:	.word 0x00f	//h00f��ɫ
green:	.word 0x3b7	//��ɫ
blue:	.word 0xcc4	//��ɫ����

//s2
wall_y1:	.word 100
wall_y2:	.word 400
wall_y3:	.word 300
wall_y4:	.word 200

//s3
playerlen:	.word 20	//��ҵĳ���
openinglen:	.word 80	//ȱ�ڵĿ��

//s4
LEDcounter:	.word 0xf0000000	//f0000000��ַ LED��Ӳ��countersw ��ַ
seg7:	.word 0xe0000000	//e0000000��ַ �߶���ʾ��
keyborad:	.word 0xd0000000	//d0000000��ַ keyboard
vram:	.word 0xc0000000	//c0000000��ַ vram
picstart:	.word 0xb0000000	//b0000000��ַ picstart
picwall:	.word 0xa0000000	//a0000000��ַ picwall
picbird:	.word 0x90000000	//90000000��ַ picbird
