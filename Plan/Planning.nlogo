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