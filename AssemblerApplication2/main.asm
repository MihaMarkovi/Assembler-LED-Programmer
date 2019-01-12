;
; AssemblerApplication2.asm
;
; Created: 1/7/2019 9:38:08 PM
; Author : Uporabnik
;

;dobrodošli v source kodi za Programator Led luèk
;automatic mode: vpišeš štiri zaporedja luèk, katere se potem ponavlajjo v zanki z razmikom 500ms
;manual mode: uporabnik vpiše zaporedje bitov, v katerem želi, da se mu luèke prižgejo
;priklopi led luèke na vhode od vkljuèno d2 do vkljuèno d4

;prvo vkljuèimo kodo knjižnice
;-----------------------------------------------------
				; za uporabo najprej klièite proceduro setupUART
				.equ baudrate = 9600

				.macro print
				.cseg
				push r16			; pazimo, da ne bi sluèajno spremenili r16, ZH, ZL
				push ZH
				push ZL

				ldi ZH, high(@0 << 1)
				ldi ZL, low(@0 << 1)
				call printstring

				pop ZL
				pop ZH
				pop r16				; vrnemo v r16 prvotno vrednost
				.endmacro


;-------------------------
;program

call setupUART

;pogovorno besedio za uvod
z_register_hello:
	ldi zh, high(hello*2)
	ldi zl, low(hello*2)
	rjmp welcome

welcome:
	ldi r21, 0x00
	lpm r16, z+
	cpi r16, 0x00
	breq choose
	call send_char
	rjmp welcome

choose:
	call get_char
	call send_char
	cpi r16, 0x6D
	breq z_register_manual
	cpi r16, 0x61
	breq z_register_automatic_1
	rjmp z_register_hello

;pogovorno besedilo za manual
z_register_manual:
	ldi zh, high(manual*2)
	ldi zl, low(manual*2)
	rjmp manual_program

manual_program:
	lpm r16, z+
	cpi r16, 0x00
	breq compare_manual
	call send_char
	rjmp manual_program

compare_manual:
	cpi r21, 0x03
	breq turn_LED_on_manual
	inc r21
	call get_char
	call send_char
	cpi r16, 0x31
	breq result_maker_1
	brne result_maker_0

result_maker_1:
	sec
	ror r17
	clc
	rjmp compare_manual

result_maker_0:
	clc
	ror r17
	rjmp compare_manual

turn_LED_on_manual:
	clc
	clr r21
	ror r17
	ror r17
	ror r17
	ldi r16, 0x0A
	call send_char
	ldi r16, 0x07
	call send_char
	out ddrd, r17
	out portd, r17
	rjmp z_register_manual

;pogovorna besedila za automatic
z_register_automatic_1:
	ldi zh, high(automatic_1*2)
	ldi zl, low(automatic_1*2)
	rjmp automatic_program_1

automatic_program_1:
	ldi r21, 0x00
	lpm r16, z+
	cpi r16, 0x00
	breq compare_automatic_1
	call send_char
	rjmp automatic_program_1

compare_automatic_1:
	cpi r21, 0x03
	breq z_register_automatic_2
	inc r21
	call get_char
	call send_char
	cpi r16, 0x31
	breq result_maker_1_1
	brne result_maker_0_1
	ldi r16, 0x0A
	call send_char

result_maker_0_1:
	clc
	ror r22
	rjmp compare_automatic_1

result_maker_1_1:
	sec
	ror r22
	clc
	rjmp compare_automatic_1

z_register_automatic_2:
	ldi zh, high(automatic_2*2)
	ldi zl, low(automatic_2*2)
	rjmp automatic_program_2

automatic_program_2:
	ldi r21, 0x00
	lpm r16, z+
	cpi r16, 0x00
	breq compare_automatic_2
	call send_char
	rjmp automatic_program_2

z_register_automatic_3:
	ldi zh, high(automatic_3*2)
	ldi zl, low(automatic_3*2)
	rjmp automatic_program_3

automatic_program_3:
	ldi r21, 0x00
	lpm r16, z+
	cpi r16, 0x00
	breq compare_automatic_3
	call send_char
	rjmp automatic_program_3

compare_automatic_3:
	cpi r21, 0x03
	breq z_register_automatic_4
	inc r21
	call get_char
	call send_char
	cpi r16, 0x31
	breq result_maker_1_3
	brne result_maker_0_3
	ldi r16, 0x0A
	call send_char

result_maker_1_3:
	sec
	ror r24
	clc
	rjmp compare_automatic_3

result_maker_0_3:
	clc
	ror r24
	rjmp compare_automatic_3

z_register_automatic_4:
	ldi zh, high(automatic_4*2)
	ldi zl, low(automatic_4*2)
	rjmp automatic_program_4

automatic_program_4:
	ldi r21, 0x00
	lpm r16, z+
	cpi r16, 0x00
	breq compare_automatic_4
	call send_char
	rjmp automatic_program_4


compare_automatic_2:
	cpi r21, 0x03
	breq z_register_automatic_3
	inc r21
	call get_char
	call send_char
	cpi r16, 0x31
	breq result_maker_1_2
	brne result_maker_0_2
	ldi r16, 0x0A
	call send_char

result_maker_0_2:
	clc
	ror r23
	rjmp compare_automatic_2

result_maker_1_2:
	sec
	ror r23
	clc
	rjmp compare_automatic_2

compare_automatic_4:
	cpi r21, 0x03
	breq turn_LED_on_automatic
	inc r21
	call get_char
	call send_char
	cpi r16, 0x31
	breq result_maker_1_4
	brne result_maker_0_4
	ldi r16, 0x0A
	call send_char

;zanka za automatic prižig LED luèk
turn_LED_on_automatic:
	clc
	clr r21
	ror r22
	ror r22
	ror r22	
	ror r23
	ror r23
	ror r23
	ror r24
	ror r24
	ror r24
	ror r25
	ror r25
	ror r25
	rjmp loop

loop:
	out ddrd, r22
	out portd, r22
	call wait
	out ddrd, r23
	out portd, r23
	call wait
	out ddrd, r24
	out portd, r24
	call wait
	out ddrd, r25
	out portd, r25
	call wait
	rjmp loop

result_maker_1_4:
	sec
	ror r25
	clc
	rjmp compare_automatic_4

result_maker_0_4:
	clc
	ror r25
	rjmp compare_automatic_4

;Wait loop. Ne spreminjaj. Delay: 500ms
wait:
    ldi  r18, 21
    ldi  r19, 75
    ldi  r20, 191
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    nop
	ret

hello: .db " Dobrodosli v programatorju luck. Izberi mode manual ali automatic(m/a): ",0
manual: .db " Dobrodosli v manual mode-u. Napisite program: ",0
automatic_1: .db " Dobrodosli v automatic mode-u. Izberite prvo zaporedje: ",0
automatic_2: .db " Izberite drugo zaporedje: ",0
automatic_3: .db " Izberite tretje zaporedje: ",0
automatic_4: .db " Izberite cetrto zaporedje: ",0

;****************************************************************************************************
;  printstring
;  Z kaže na zaèetek niza v PROGRAMskem pomnilniku (CSEG)
;****************************************************************************************************

				.cseg
printstring:	lpm r16, Z+			; naloži znak in premakni kazalec Z naprej
				cpi r16, 0			; ali je konec niza (niz se konèa z NULL)
				breq stopprinting	; da, skoèi na konec
				call send_char		; ne, pošlji znak
				rjmp printstring	; na vrsti je naslednji znak, skoèi tja
stopprinting:	ret				                

;****************************************************************************************************
;  poslji_hex
;  r16 - stevilka, ki jo zelimo izpisati na UART 
;****************************************************************************************************
				; v r16 damo vrednost, na UART dobimo dve ASCII šestnajstiški števki  (0xFF --> 'FF')
send_hex:		push r16			; kako pretvorimo vrednosti od 0 do 9 v '0' do '9'?
									; kaj pa od 10 do 15 v 'A' do 'F'?
				swap r16			; zamenjamo visoki in nizki del byta
				andi r16, 0x0F		; zanimajo nas samo štirje biti

				cpi r16, 0x0A		; primerjaj z deset
				brcs manjsa_od_10_1
				subi r16, -7		; èe ni manjša od deset, je osnova 'A', r16 je vsaj 10, prištejemo še '0', je potem 58, manjka še 7
manjsa_od_10_1:						; sicer je osnova '0', prištejemo 48 ('0')
				subi r16, -48
				call send_char

				pop r16
				andi r16, 0x0F		; zanimajo nas samo štirje biti, tokrat so to spodnji štirje

				cpi r16, 0x0A		; primerjaj z deset
				brcs manjsa_od_10_2
				subi r16, -7		; èe ni manjša od deset, je osnova 'A', r16 je vsaj 10, prištejemo še '0', je potem 58, manjka še 7
manjsa_od_10_2:						; sicer je osnova '0', prištejemo 48 ('0')
				subi r16, -48
				call send_char

				ret
				
;****************************************************************************************************
;  setupUART
;  pripravi serijska vrata na prenos podatkov, 9600 baud
;
;****************************************************************************************************
setupUART:		; pripravi serijska vrata
				; ne sekirajte se, èe še ne veste, èesa vsega ne poznate

				; 
				; vrednosti not npr. TXEN0 in UBRR0H dobimo v datoteki m328pdef.inc 
				; in so lahko druga?ne glede na model mikrokontrolerja

				; 9600 baudov @ 16Mhz
				; v IO register UBBR0 naložimo baudrate / 8

				ldi r16, 0x67
				ldi r17, 0x00
				sts UBRR0L, r16
				sts UBRR0H, r17

				; RXEN0 = 4, TXEN0 = 3, znak << pomeni pomik v levo, >> desno
				; 1<<TXEN0 = 0x40 (0b00000001 --> 0b00001000)
				ldi r16, (1<<RXEN0)|(1<<TXEN0) ; vkljuèimo bita za sprejem in za oddajo - pina dobita RX in TX funkcijo
				sts UCSR0B,r16

				ldi r16, (3<<UCSZ00) ; 8 bitov, 1 stop bit
				sts UCSR0C,r16
				clr r16
				sts UCSR0A, r16

				ret

;****************************************************************************************************
; procedura pošlje znak v r16 po UART
;
;****************************************************************************************************
				; poèakajmo, da bo oddajni vmesni pomnilnik na voljo
send_char:		; takrat bo bit UDRE0 enak 1
				push r16				; spravi r16 na sklad, ker bomo po njem pacali 
poskusi_poslati:
				lds r16, UCSR0A
				sbrs r16,UDRE0			; preskoèi naslednjo instrukcijo, èe je ta bit 1
				rjmp poskusi_poslati	; bit še ni 1, skoèi nazaj na preverjanje
									
				pop r16					; daj podatek (r16) v vmesni pomnilnik za UART, 
				sts UDR0,r16	
				ret

;****************************************************************************************************
; procedura sprejme znak  po UART v r16
;
;****************************************************************************************************

get_char:		; poèakajmo, da bo znak prispel, bit RXC0 bo takrat 1
				lds r16, UCSR0A
				sbrs r16, RXC0
				rjmp get_char

				lds r16, UDR0
vrnise:			ret

;****************************************************************************************************
;  8-bitno deljenje z 10
;  deli r16 z 10, r17 je ostanek
;
;****************************************************************************************************

div10_8bit:		push r0
				push r1
				push r16
				inc r16			; some magic
				brne dobro
				dec r16
dobro:			ldi r17, 51		; more magic
				mul r16, r17	; mind blown
				lsr r1			; r1 = r16/10 (celi del, seveda)

				mov r16, r1
				ldi r17, 10
				mul r1, r17
				pop r17
				sub r17, r0		; ostanek
				pop r1
				pop r0				
				ret				; confused?

;****************************************************************************************************
;  izpiši 8-bitno število kot ascii
;  r16 število
;  r17 mest
;
;****************************************************************************************************

print_8bit_base10:
				push r18			; pacamo po r18
				mov r18, r17
				clr r17
				push r17
naslednja_cifra:					; najprej izracunamo stevke in jih damo na stack
				call div10_8bit		; r16 = r16 / 10, r17 je ostanek
				ori r17, 0x30		; naredimo iz njega ASCII cifro (npr. 2 => 0x32 = '2')
				push r17			; ker je ostanke potrebno izpisati v obratnem vrstnem redu
				dec r18				; jih damo na sklad, vendar samo toliko cifer max, kot je bilo podano
				brne naslednja_cifra	; èe imamo dovolj števk, nehamo
							
izpisi_cifre:   pop r16
				or r16, r16			; zadnja cifra je ascii NULL (=0x00)
				breq konec_izpisa
				call send_char
				rjmp izpisi_cifre

konec_izpisa:	pop r18				; popravimo r18 nazaj...
				ret

dump_registers:						; grda procedura... ampak deluje.. :p
				push r31
				push r30
				push r29
				push r28
				push r27
				push r26
				push r25
				push r24
				push r23
				push r22
				push r21
				push r20
				push r19
				push r18
				push r17
				push r16
				push r15
				push r14
				push r13
				push r12
				push r11
				push r10
				push r9
				push r8
				push r7
				push r6
				push r5
				push r4				
				push r3
				push r2
				push r1
				push r0

				in ZH, SPH
				in ZL, SPL
				ldi r18, 32		; 32 registrov na skladu
				clr r19			; števec registrov
				ld r16, Z+		; vrednost na vrhu skladu nima pomena
naslednji_register:
				ldi r16, 'r'
				call send_char

				mov r16, r19
				inc r19
				ldi r17, 2
				call print_8bit_base10

				ldi r16, ':'
				call send_char

				ld r16, Z+
				call send_hex
				ldi r16,0x20
				call send_char
				call send_char

				mov r16, r19
				andi r16, 0x07
				brne no_new_line

				ldi r16, 0x0d
				call send_char
				ldi r16, 0x0a
				call send_char
				call send_char

no_new_line:	dec r18
				brne naslednji_register

				pop r0
				pop r1
				pop r2
				pop r3
				pop r4
				pop r5
				pop r6
				pop r7
				pop r8
				pop r9
				pop r10
				pop r11
				pop r12
				pop r13
				pop r14
				pop r15
				pop r16
				pop r17
				pop r18
				pop r19
				pop r20
				pop r21
				pop r22
				pop r23
				pop r24
				pop r25
				pop r26
				pop r27
				pop r28
				pop r29
				pop r30
				pop r31

				ret				; we are done here

				.dseg
StackHI:		.byte 1
StackLO:		.byte 1

;konec knjižnice
;---------------------------------------------------------------

