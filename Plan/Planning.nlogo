Ther's a report

Planning:
  Patches:
    -Yellow
    -Red (Toxic waste)
      - Must reappear in the world in such a way that the configured levels are maintained
  throughout the simulation
      -Configurable:
        - setup function: amount: between 0% and 15%
    -Green (food) 
      - Must reappear in the world in such a way that the configured levels are maintained
  throughout the simulation
      -Configurable:
        - setup function: amount: between 5% and 20%
        - Energy obtained: between 1 and 50
    -Blue (deposit, where agents can deposit garbage)
      - varies between 1 and 10
    -Black (when glutton eats a green cell)

Agentes:
    - Gluttons:
      -(configurable initial value).
      -gains energy from eating
      -lose energy if they
contact or sense waste (see further details)
      -His main objective is to find food in order to
  maintain their energy levels, thus ensuring their survival
      -Characteristics:
        -dies on waste cell
        -if percieves waste cell 
          - energy decrieses 5% if normal garbadge
          - energy decreases 10% if toxic garbadge
        -Auto eats green cells and leaves black cell
        -Percieves the cell in front, to the left and to the right
        -must choose an action that optimises it's survival
        -Actions: 
          (in each iteration can  perform 1 of these actions)
          (each action takes a unit of energy)
          -Move to the front
          -Rotate 90 clock-wise
          -Rotate 90º anti-clock-wis
        
    - Cleaners:
      -(configurable initial value).
      -gains energy from eating and deposit waste in dumps
      -His main objective is to find food in order to
  maintain their energy levels, thus ensuring their survival
      -Characteristics:
        - Percieves the cell in front and to the right
        - Actions:
          - move forward
          - turn 90 right
          - turn 90 left
        have memory:
         they have a single integer variable where the amount of waste they transport is registered. The update should be done automatically:
          § When collecting a normal waste it should be increased by one unit;
          § When collecting a toxic waste it must be increased by two units;
          § When finding the deposit, the variable resets to zero, the accumulated in the deposit is updated and the Cleaner energy level is increased by 10*number of cells deposited. 
        - can transport limited amount of waste (configurable)
        - when limit reach go find a dump to put the waste
        when limit reached, food gives less
        - when garbadge is collected cell turns black (unless limit has been reached)
        - food energy gain rules:
            Cleaners automatically ingest the food found in the current cell. If this happens, the cell turns black and the agent's energy increases according to the  following rule:
            § If the number of wastes you transport is less than half the limit, the energy increase corresponds to the value indicated in the environment setting.
            § Otherwise, the energy increase corresponds to half the value indicated in the setting.


Functions:
  Setup
    - all agents receive the same initial amount of energy (configurable value).

  Go
    - in each iteration they lose a unit of energy
    - if energy reaches value <= 0 the agent dies


  ask gluttons [
    
    ; check energy lost through percieved waste
    if [pcolor] of patch-ahead 1 = red [; check if any color red
      set energy round(energy * 0.9)         ; 10% loss of energy   
    ]
    if [pcolor] of patch-at 0 1 = red [
      set energy round(energy * 0.9)       
    ]
    if [pcolor] of patch-at 0 -1 = red [
      set energy round(energy * 0.9)
    ]
    
    if [pcolor] of patch-ahead 1 = yellow [; check if any color yellow
      set energy round(energy * 0.95)           ; 5% loss of energy   
    ]
    if [pcolor] of patch-at 0 1 = yellow [
      set energy round(energy * 0.95)       
    ]
    if [pcolor] of patch-at 0 -1 = yellow [
      set energy round(energy * 0.95)
    ]
    
    
    ifelse [pcolor] of patch-ahead 1 != green and [pcolor] of patch-at 0 1 != green and [pcolor] of patch-at 0 -1 != green [
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
          ifelse [pcolor] of patch-at 0 1 != red and [pcolor] of patch-at 0 1 != yellow [ ; look right
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
          ifelse [pcolor] of patch-at 0 -1 != red and [pcolor] of patch-at 0 -1 != yellow [ ; look left
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

    ] [
      ;at least one green
      if [pcolor] of patch-ahead 1 = green [
        set energy energy - 1 ; gasta uma unidade de energia
        forward 1
      ]
      if [pcolor] of patch-at 0 1 = green [
        set energy energy - 1 ; gasta uma unidade de energia
        right 90
      ]
      if [pcolor] of patch-at 0 -1 = green [
        set energy energy - 1 ; gasta uma unidade de energia
        left 90
      ]      
    ]
    
    
    
    if pcolor = green [
      set energy energy + food_energy_amount
      set pcolor black
    ]
  ]
    




ifelse [pcolor] of patch-at 0 1 != red and [pcolor] of patch-at 0 1 != yellow [



    
;    ifelse [pcolor] of patch-ahead 1 != red and [pcolor] of patch-ahead 1 != yellow [
;      ; no waste ahead 
;      set energy energy - 1 ; gasta uma unidade de energia
;      forward 1
;    ] [
;      ; waste ahead
;      ; patch-at 0 1 -> right
;      ; patch-at 0 -1 -> left
;      ifelse random 2 = 0 [ ; look right or left first
;        ifelse [pcolor] of patch-at 0 1 != red and [pcolor] of patch-at 0 1 != yellow [ ; look right
;          ; no waste right
;          set energy energy - 1
;          right 90
;        ] [
;          ; waste right
;          ; wether or not there is waste to the left we turn to the left
;          set energy energy - 1
;          left 90
;        ]
;      ] [ 
;        ifelse [pcolor] of patch-at 0 -1 != red and [pcolor] of patch-at 0 -1 != yellow [ ; look left
;          ; no waste right
;          set energy energy - 1
;          left 90
;        ] [
;          ; waste right
;          ; wether or not there is waste to the left we turn to the left
;          set energy energy - 1
;          right 90
;        ]
;      ]
;    ]



    if pcolor = green [
      set energy energy + food_energy_amount
      set pcolor black
    ]
  ]


to move-comiloes2
  ask comiloes
  [
    ifelse [pcolor] of patch-here = green
    [
      set pcolor black
      set energy energy + quantEnergia
    ]
    [
      ifelse [pcolor] of patch-ahead 1 = green
      [
        fd 1
      ]
      [
        ifelse [pcolor] of patch-ahead 1 = red or [pcolor] of patch-ahead 1 = yellow
        [
          rt 90
          ifelse [pcolor] of patch-ahead 1 = red
          [
            set energy round(energy * 0.9)
          ]
          [
            set energy round(energy * 0.95)
          ]

        ]
        [
          ifelse random 101 < 90
          [
            fd 1
          ]
          [
            ifelse random 101 < 50
            [
              rt 90
            ]
            [
              lt 90
            ]
          ]
        ]
      ]
    ]
  ]

end


;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================
;; REEEEEE ===================================================================

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
  ; check-death ; Ver se morreram
  regrow-terrain ; Mantém níveis adequados das patches
  if count turtles = 0 [ ; Ver se termina
    stop
  ]
  display-labels
  tick
end

to move-cleaners
  ask cleaners [
    
    if pcolor = green [
      set pcolor black
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
     ]
    ]
    if pcolor = yellow [
     if waste + 1 <= max_waste [
       set waste (waste + 1)
       set pcolor black
     ]
    ]
    if pcolor = blue [
       set energy round(energy + (10 * waste))
       set waste 0
    ]

    ; if waste != full
        ; if waste = full - 1
          ; vê lixo normal a toda a volta e anda, se não encontra
          ; vê food a toda a volta e anda e anda, se não enconra 
          ; anda
        ; else
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
          ; vê lixo normal a toda a volta e anda, se não encontra
          ; vê food a toda a volta e anda e anda, se não enconra 
          ; anda
      ] [
          ; vê lixo toxio a toda a volta e anda, se não encontra
          ; vê lixo normal a toda a volta e anda, se não encontra
          ; vê food a toda a volta e anda e anda, se não enconra 
          ; anda
      ]
    ] [
        ; vê depositos a toda a volta e anda, se não encontra
        ; vê food a toda a volta e anda e anda, se não enconra 
        ; desvia-se dos lixos
        ; anda
    ]




;===========================================================
; vê lixo normal a toda a volta e anda, se não encontra
; vê food a toda a volta e anda e anda, se não enconra 
; anda

    ; vê lixo normal a toda a volta e anda, se não encontra
    ifelse [pcolor] of patch-ahead 1 = yellow [
      set energy energy - 1 ; gasta uma unidade de energia
      forward 1
    ] [
      ifelse [pcolor] of patch-right-and-ahead 90 1 = yellow [
        set energy energy - 1 ; gasta uma unidade de energia
        right 90
      ] [
        ; vê food a toda a volta e anda e anda, se não enconra 
        ifelse [pcolor] of patch-ahead 1 = green [
          set energy energy - 1 ; gasta uma unidade de energia
          forward 1
        ] [
          ifelse [pcolor] of patch-right-and-ahead 90 1 = green [
            set energy energy - 1 ; gasta uma unidade de energia
            right 90
          ] [
            ; anda
            set energy energy - 1 ; gasta uma unidade de energia
            forward 1
          ]
        ]
        
      ]
    ]


;===========================================================
; vê lixo toxio a toda a volta e anda, se não encontra
; vê lixo normal a toda a volta e anda, se não encontra
; vê food a toda a volta e anda e anda, se não enconra 
; anda

; vê lixo toxic a toda a volta e anda, se não encontra
    ifelse [pcolor] of patch-ahead 1 = red [
      set energy energy - 1 ; gasta uma unidade de energia
      forward 1
    ] [
      ifelse [pcolor] of patch-right-and-ahead 90 1 = red [
        set energy energy - 1 ; gasta uma unidade de energia
        right 90
      ] [
        ; vê food a toda a volta e anda e anda, se não enconra 
        ifelse [pcolor] of patch-ahead 1 = green [
          set energy energy - 1 ; gasta uma unidade de energia
          forward 1
        ] [
          ifelse [pcolor] of patch-right-and-ahead 90 1 = green [
            set energy energy - 1 ; gasta uma unidade de energia
            right 90
          ] [
            ; anda
            set energy energy - 1 ; gasta uma unidade de energia
            forward 1
          ]
        ]
        
      ]
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

to move-gluttons
  ask gluttons [
    
    if pcolor = green [
      set energy energy + food_energy_amount
      set pcolor black
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
;  ask turtles [
;    set label ""
;    if show_energy [
;      ; Se botão está on, mostra labels
;      set label energy
;    ]
;  ]
  ask cleaners [
    set label ""
    set label waste
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

;;Passo 4
to ChangeArmadilhas
  ask patches with [pcolor = red][
    ask one-of patches with [not any? turtles-here and pcolor != red and pcolor != blue and pcolor != yellow]
       [set pcolor red]
    set pcolor black
  ]
end

;;Passo 6
to Mimetismo
ask gluttons[
  ifelse any? cleaners-on neighbors
    [set color yellow]
    [set color blue]
]
end