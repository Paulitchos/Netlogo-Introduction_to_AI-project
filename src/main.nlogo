;;AGENTE REACTIVO
;;food_energy_amount
;;num_gluttons
;;num_cleaners
;;starting_energy
;;max_waste
;;tick
;;num_killers
;;food_energy_amount
;;starting_toxic_waste
;;starting_normal_waste
;;starting_food
;;n_deposits

;;Agents
breed[gluttons glutton] ; cria agentes glutton (tens que defenir) // como te vais referir a eles pelo sigular e pelo plural)
breed[cleaners cleaner] ;
turtles-own [energy] ; todos os agentes têm energy
cleaners-own [waste] ; ; os cleaners podem carregar comida

;;Global variebles
globals [blue-nest  yellow-nest]  ; declaração de 2 variáveis globais

;;Passo 2
to setup
  clear-all
  reset-ticks
  setup-patches
  setup-turtles
 end

;;Passo 2
to setup-patches
  clear-all
  set-patch-size 15
  ask patches with [pcolor = black] [
    if random 101 < starting_toxic_waste [
      set pcolor red
    ]
  ]
  ask patches with [pcolor = black] [
    if random 101 < starting_normal_waste [
      set pcolor yellow
    ]
  ]
  ask patches with [pcolor = black] [
    if random 101 < starting_food [
      set pcolor green
    ]
  ]
  repeat n_deposits [ ; 1 a 10
    ask one-of patches with [pcolor = black] [
      set pcolor blue
    ]
  ]
  reset-ticks
end


;;Passo 2
to setup-turtles
  create-gluttons num_gluttons [
    set shape "turtle"
    set color brown
    ; colocação junta-se aos caracóis (abaixo)
  ]
  create-cleaners num_cleaners [ ; Criar
    set shape "truck"
    set color white
    set waste 0
  ]

  ask turtles [ ; Comum a todos agentes
                ; Posição inicial fora de waste
    set heading 0      ; turtle is now facing north
    set size 2
    setxy random-xcor random-ycor
    while [pcolor = red or pcolor = yellow or pcolor = green] [
      setxy random-xcor random-ycor
    ]
    set energy starting_energy ; energy inicial
  ]
  display-labels
end

to go
  move-gluttons
  move-cleaners
  check-death ; Ver se morreram
  reproduce
  regrow-terrain ; Mantém níveis adequados das patches
  if count turtles = 0 [ ; Ver se termina
    stop
  ]
  display-labels
  tick
  if ticks >= ticks_end and infinite_ticks != true [stop]
end

to move-cleaners
  ask cleaners [

    if pcolor = green [
      set pcolor black
      ask one-of patches with [pcolor = black] [
        set pcolor green ]
      ifelse waste < (max_waste / 2) [
        set energy energy + food_energy_amount
      ] [
        set energy energy + (food_energy_amount / 2)
      ]
    ]
    if pcolor = red [
      if waste + 2 <= max_waste [
        set waste (waste + 2)
        set pcolor black
        ask one-of patches with [pcolor = black] [
        set pcolor red ]
      ]
    ]
    if pcolor = yellow [
      if waste + 1 <= max_waste [
        set waste (waste + 1)
        set pcolor black
        ask one-of patches with [pcolor = black] [
        set pcolor yellow ]
      ]
    ]
    if pcolor = blue [
      set energy round(energy + (10 * waste))
      set waste 0
    ]

    ; PSEUDOCODIGO
    ; if waste != full
    ; if waste = full - 1
    ; vê depositos a toda a volta e anda, se não encontra
    ; vê lixo normal a toda a volta e anda, se não encontra
    ; vê food a toda a volta e anda e anda, se não enconra
    ; anda
    ; else
    ; vê depositos a toda a volta e anda, se não encontra
    ; vê lixo toxio a toda a volta e anda, se não encontra
    ; vê lixo normal a toda a volta e anda, se não encontra
    ; vê food a toda a volta e anda e anda, se não enconra
    ; anda
    ; else
    ; vê depositos a toda a volta e anda, se não encontra
    ; vê food a toda a volta e anda e anda, se não enconra
    ; desvia-se dos lixos
    ; anda


    ifelse waste != max_waste [

      ifelse waste = max_waste - 1[
        ; vê depositos a toda a volta e anda, se não encontra
        ; vê lixo normal a toda a volta e anda, se não encontra
        ; vê food a toda a volta e anda e anda, se não enconra
        ; anda

        ; vê lixo normal a toda a volta e anda, se não encontra
        ifelse [pcolor] of patch-ahead 1 = blue and waste > 1 [
          set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
          forward 1
        ] [
          ifelse [pcolor] of patch-right-and-ahead 90 1 = blue [
            set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
            right 90
          ] [
            ifelse [pcolor] of patch-ahead 1 = yellow [
              set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
              forward 1
            ] [
              ifelse [pcolor] of patch-right-and-ahead 90 1 = yellow [
                set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                right 90
              ] [
                ; vê food a toda a volta e anda e anda, se não enconra
                ifelse [pcolor] of patch-ahead waste = green [
                  set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                  forward 1
                ] [
                  ifelse [pcolor] of patch-right-and-ahead 90 1 = green [
                    set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                    right 90
                  ] [
                    ; anda

                    ; para impedir que fiquem presos em reservatorios com lixo à volta
                    ifelse random 501 = 500 [
                      set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                      forward 1
                    ] [
                      ifelse random 501 = 500 [
                        set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                        right 1
                      ] [
                        ifelse random 501 = 500 [
                          set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                          left 1
                        ] [

                          set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                          forward 1
                        ]
                      ]
                    ]



                  ]
                ]
              ]
            ]
          ]
        ]

      ] [
        ; vê depositos a toda a volta e anda, se não encontra
        ; vê lixo toxio a toda a volta e anda, se não encontra
        ; vê lixo normal a toda a volta e anda, se não encontra
        ; vê food a toda a volta e anda e anda, se não enconra
        ; anda

        ifelse [pcolor] of patch-ahead 1 = blue [

          ; para impedir que fiquem presos em reservatorios com lixo à volta
          ifelse random 501 = 500 [
            set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
            forward 1
          ] [
            ifelse random 501 = 500 [
              set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
              right 1
            ] [
              ifelse random 501 = 500 [
                set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                left 1
              ] [

                set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                forward 1

              ]
            ]
          ]

        ] [
          ifelse [pcolor] of patch-right-and-ahead 90 1 = blue [

            ; para impedir que fiquem presos em reservatorios com lixo à volta
            ifelse random 501 = 500 [
              set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
              forward 1
            ] [
              ifelse random 501 = 500 [
                set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                right 1
              ] [
                ifelse random 501 = 500 [
                  set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                  left 1
                ] [

                  set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                  right 90

                ]
              ]
            ]


          ] [
            ifelse [pcolor] of patch-ahead 1 = red [
              set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
              forward 1
            ] [
              ifelse [pcolor] of patch-right-and-ahead 90 1 = red [
                set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                right 90
              ] [
                ; vê lixo normal a toda a volta e anda, se não encontra
                ifelse [pcolor] of patch-ahead 1 = yellow [
                  set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                  forward 1
                ] [
                  ifelse [pcolor] of patch-right-and-ahead 90 1 = yellow [
                    set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                    right 90
                  ] [
                    ; vê food a toda a volta e anda e anda, se não enconra
                    ifelse [pcolor] of patch-ahead 1 = green [
                      set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                      forward 1
                    ] [
                      ifelse [pcolor] of patch-right-and-ahead 90 1 = green [
                        set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                        right 90
                      ] [
                        ; anda


                        ; para impedir que fiquem presos em reservatorios com lixo à volta
                        ifelse random 501 = 500 [
                          set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                          forward 1
                        ] [
                          ifelse random 501 = 500 [
                            set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                            right 1
                          ] [
                            ifelse random 501 = 500 [
                              set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                              left 1
                            ] [

                              set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                              forward 1

                            ]
                          ]
                        ]



                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]



      ]
    ] [
      ; vê depositos a toda a volta e anda, se não encontra
      ; vê food a toda a volta e anda e anda, se não enconra
      ; desvia-se dos lixos
      ; anda

      ; vê depositos a toda a volta e anda, se não encontra
      ifelse [pcolor] of patch-ahead 1 = blue [
        set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
        forward 1
      ] [
        ifelse [pcolor] of patch-right-and-ahead 90 1 = blue [
          set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
          right 90
        ] [
      ; vê food a toda a volta e anda e anda, se não enconra
          ifelse [pcolor] of patch-ahead 1 = green [
            set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
            forward 1
          ] [
            ifelse [pcolor] of patch-right-and-ahead 90 1 = green [
              set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
              right 90
            ] [
              ; anda

              ; para impedir que fiquem presos em reservatorios com lixo à volta
              ifelse random 501 = 500 [
                set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                forward 1
              ] [
                ifelse random 501 = 500 [
                  set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                  right 1
                ] [
                  ifelse random 501 = 500 [
                    set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                    left 1
                  ] [

                    set energy energy - round((1 + waste) / 2) ; gasta uma unidade de energia
                    forward 1
                  ]
                ]
              ]


            ]
          ]
        ]
      ]



    ]









  ]
end

to move-gluttons
  ask gluttons [

    if pcolor = green [
      set energy energy + food_energy_amount
      set pcolor black
      ask one-of patches with [pcolor = black] [
        set pcolor green ]
    ]

    ; check energy lost through percieved waste
    if [pcolor] of patch-ahead 1 = red [; check if any color red
      set energy round(energy * 0.9)         ; 10% loss of energy
    ]
    if [pcolor] of patch-right-and-ahead 90 1 = red [
      set energy round(energy * 0.9)
    ]
    if [pcolor] of patch-right-and-ahead -90 1 = red [
      set energy round(energy * 0.9)
    ]

    if [pcolor] of patch-ahead 1 = yellow [; check if any color yellow
      set energy round(energy * 0.95)           ; 5% loss of energy
    ]
    if [pcolor] of patch-right-and-ahead 90 1 = yellow [
      set energy round(energy * 0.95)
    ]
    if [pcolor] of patch-right-and-ahead -90 1 = yellow [
      set energy round(energy * 0.95)
    ]


    ifelse [pcolor] of patch-ahead 1 = green [
      set energy energy - 1 ; gasta uma unidade de energia
      forward 1
    ] [
      ifelse [pcolor] of patch-right-and-ahead 90 1 = green [
        set energy energy - 1 ; gasta uma unidade de energia
        right 90
      ] [
        ifelse [pcolor] of patch-right-and-ahead -90 1 = green [
          set energy energy - 1 ; gasta uma unidade de energia
          left 90
        ] [




          ;ifelse [pcolor] of patch-ahead 1 != green and [pcolor] of patch-right-and-ahead 90 1 != green and [pcolor] of patch-right-and-ahead -90 1 != green[
          ;no greens

          ifelse [pcolor] of patch-ahead 1 != red and [pcolor] of patch-ahead 1 != yellow [
            ; no waste ahead
            set energy energy - 1 ; gasta uma unidade de energia
            forward 1
          ] [
            ; waste ahead
            ; patch-at 0 1 -> right
            ; patch-at 0 -1 -> left
            ifelse random 2 = 0 [ ; look right or left first
              ifelse [pcolor] of patch-right-and-ahead 90 1 != red and [pcolor] of patch-right-and-ahead 90 1 != yellow [ ; look right
                                                                                              ; no waste right
                set energy energy - 1
                right 90
              ] [
                ; waste right
                ; wether or not there is waste to the left we turn to the left
                set energy energy - 1
                left 90
              ]
            ] [
              ifelse [pcolor] of patch-right-and-ahead -90 1 != red and [pcolor] of patch-right-and-ahead -90 1 != yellow [ ; look left
                                                                                                ; no waste right
                set energy energy - 1
                left 90
              ] [
                ; waste right
                ; wether or not there is waste to the left we turn to the left
                set energy energy - 1
                right 90
              ]
            ]
          ]




        ]
      ]
    ]
  ]
end

to check-death
  ask turtles [
    if energy <= 0
    [
      die
    ]
  ]
end

to display-labels ; Colocar agentes a mostrar energy
  ifelse show_waste [
    ask cleaners [
      set label ""
      set label waste
    ]
    ask gluttons [
      set label ""
    ]
  ] [
    ask turtles [
      set label ""
      if show_energy [
        ; Se botão está on, mostra labels
        set label energy
      ]
    ]
  ]
end

to reproduce
  ask gluttons [
    if reproduce_gluttons [
      if energy > food_energy_amount [ ; Se atinge limiar de energia, reproduz c/ prob
        if random 101 < reproduction_chance [ ; Ver probabilidade
          set energy round(energy / 2) ; Divide energia / 2 e arredonda
          hatch 1 [jump 5]
          ; Reproduz-se, filho aparece à frente
        ]
      ]
    ]
  ]
  ask cleaners [
    if reproduce_cleaners [
      if energy > food_energy_amount [ ; Se atinge limiar de energia, reproduz c/ prob
        if random 101 < reproduction_chance [ ; Ver probabilidade
          set energy round(energy / 2) ; Divide energia / 2 e arredonda
          hatch 1 [jump 5]
          ; Reproduz-se, filho aparece à frente
        ]
      ]
    ]
  ]
end

to spawn_gluttons
  create-gluttons 5 [
    set shape "turtle"
    set color brown
    ; colocação junta-se aos caracóis (abaixo)
    set heading 0      ; turtle is now facing north
    set size 2
    setxy random-xcor random-ycor
    while [pcolor = red or pcolor = yellow or pcolor = green] [
      setxy random-xcor random-ycor
    ]
    set energy starting_energy ; energy inicial
  ]
end

to spawn_cleaners
  create-cleaners 5 [
    set shape "truck"
    set color white
    set waste 0
    set heading 0      ; turtle is now facing north
    set size 2
    setxy random-xcor random-ycor
    while [pcolor = red or pcolor = yellow or pcolor = green] [
      setxy random-xcor random-ycor
    ]
    set energy starting_energy ; energy inicial
  ]
end

to regrow-terrain

  if count patches with [pcolor = green] < count patches * 0.01 * starting_food [ ; calculate the percentage of the initial value
    ask one-of patches with [pcolor = black ] [
      set pcolor green
    ]
  ]
  if count patches with [pcolor = red] < count patches * 0.01 * starting_toxic_waste [ ; calculate the percentage of the initial value
    ask one-of patches with [pcolor = black ] [
      set pcolor red
    ]
  ]
  if count patches with [pcolor = yellow] < count patches * 0.01 * starting_normal_waste [ ; calculate the percentage of the initial value
    ask one-of patches with [pcolor = black ] [
      set pcolor yellow
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
417
10
920
514
-1
-1
15.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
23
10
87
43
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
289
10
352
43
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
392
527
548
560
food_energy_amount
food_energy_amount
1
50
26.0
1
1
NIL
HORIZONTAL

SLIDER
587
527
743
560
starting_toxic_waste
starting_toxic_waste
0
15
12.0
1
1
NIL
HORIZONTAL

SLIDER
392
572
548
605
starting_food
starting_food
5
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
587
573
743
606
n_deposits
n_deposits
1
10
10.0
1
1
NIL
HORIZONTAL

INPUTBOX
117
330
194
390
num_gluttons
30.0
1
0
Number

INPUTBOX
204
331
287
391
num_cleaners
50.0
1
0
Number

INPUTBOX
302
332
388
392
starting_energy
100.0
1
0
Number

INPUTBOX
20
330
98
390
max_waste
5.0
1
0
Number

MONITOR
65
477
146
522
Toxic Waste
count patches with [pcolor = red]
17
1
11

MONITOR
159
477
249
522
Normal Waste
count patches with [pcolor = yellow]
17
1
11

MONITOR
262
477
349
522
Food
count patches with [pcolor = green]
17
1
11

SLIDER
778
528
934
561
starting_normal_waste
starting_normal_waste
0
15
13.0
1
1
NIL
HORIZONTAL

PLOT
0
48
387
327
Agents
Interactions
Number of Agents
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"num_gluttons" 1.0 0 -13840069 true "" "plot count gluttons"
"num_cleaners" 1.0 0 -14454117 true "" "plot count cleaners"

SWITCH
49
398
199
431
show_energy
show_energy
0
1
-1000

SWITCH
50
438
199
471
show_waste
show_waste
1
1
-1000

SLIDER
776
574
932
607
reproduction_chance
reproduction_chance
0
100
1.0
1
1
NIL
HORIZONTAL

BUTTON
208
398
364
431
spawns 5 glutton
spawn_gluttons
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
206
438
363
471
spawns 5 cleaner
spawn_cleaners
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
12
526
186
559
reproduce_gluttons
reproduce_gluttons
0
1
-1000

SWITCH
200
526
376
559
reproduce_cleaners
reproduce_cleaners
1
1
-1000

INPUTBOX
69
567
192
627
ticks_end
100.0
1
0
Number

SWITCH
202
581
326
614
infinite_ticks
infinite_ticks
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

This section could give a general understanding of what the model is trying to show or explain.

## HOW IT WORKS

This section could explain what rules the agents use to create the overall behavior of the model.

## HOW TO USE IT

This section could explain how to use the model, including a description of each of the items in the interface tab.

## THINGS TO NOTICE

This section could give some ideas of things for the user to notice while running the model.

## THINGS TO TRY

This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.

## EXTENDING THE MODEL

This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.

## NETLOGO FEATURES

This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab.  It might also point out places where workarounds were needed because of missing features.

## RELATED MODELS

This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.

## CREDITS AND REFERENCES

This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
