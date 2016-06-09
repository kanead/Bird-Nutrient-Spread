extensions[gis]
globals [ireland patch-scale day freshwater ocean land fresh-nutrients other-nutrients]
breed [gulls gull]
breed [nutrients nutrient]
breed [foods food]
gulls-own [energy  x0 y0]
patches-own [ landcover ]

;##########################################################################################
;; SETUP COMMANDS
;##########################################################################################

to setup-ireland
  clear-all

  ask patches [set pcolor white ]
  ask patch 0 0
 [
    set pcolor blue
    ask patches in-radius 80 [set pcolor blue]
  ]

  create-gulls n-gulls [set color white
  setxy 0 0
  set size 1
  set shape "hawk"
  set energy 10800 ;; 3 hours flight time, 3 hours to fly back
  ;set heading random 360
  ;face patch -11 10
 ]
 ;  set ireland gis:load-dataset "land use by gull radius.shp"
    set ireland gis:load-dataset "40km gull radius .shp"
  gis:set-world-envelope gis:envelope-of ireland

  foreach gis:feature-list-of ireland
  [ if gis:property-value ? "CODE_12" = "523" [ gis:set-drawing-color blue gis:fill ? 2.0] ;; sea and ocean ; present
    if gis:property-value ? "CODE_12" = "522" [ gis:set-drawing-color sky  gis:fill ? 2.0] ;; estuaries ; present
    if gis:property-value ? "CODE_12" = "521" [ gis:set-drawing-color sky  gis:fill ? 2.0] ;; coastal lagoons ; present
    if gis:property-value ? "CODE_12" = "512" [ gis:set-drawing-color sky  gis:fill ? 2.0] ;; water bodies ; absent
    if gis:property-value ? "CODE_12" = "511" [ gis:set-drawing-color sky  gis:fill ? 2.0] ;; water courses ; absent
    if gis:property-value ? "CODE_12" = "423" [ gis:set-drawing-color sky  gis:fill ? 2.0] ;; intertidal flats ; present
    if gis:property-value ? "CODE_12" = "421" [ gis:set-drawing-color sky  gis:fill ? 2.0] ;; salt marshes ; present
    if gis:property-value ? "CODE_12" = "412" [ gis:set-drawing-color sky  gis:fill ? 2.0] ;; peat bogs ; absent
    if gis:property-value ? "CODE_12" = "411" [ gis:set-drawing-color sky  gis:fill ? 2.0] ;; inland marshes ; absent
    if gis:property-value ? "CODE_12" = "333" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; sparsely vegetated areas
    if gis:property-value ? "CODE_12" = "332" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; bare rock
    if gis:property-value ? "CODE_12" = "331" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; beaches, dunes and sand plains
    if gis:property-value ? "CODE_12" = "324" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; transitional woodland shrub
    if gis:property-value ? "CODE_12" = "322" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; moors and heathland
    if gis:property-value ? "CODE_12" = "321" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; natural grassland
    if gis:property-value ? "CODE_12" = "313" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; mixed forest
    if gis:property-value ? "CODE_12" = "312" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; coniferous forest
    if gis:property-value ? "CODE_12" = "311" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; broad-leaved forest
    if gis:property-value ? "CODE_12" = "243" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; agriculture cum vegetation
    if gis:property-value ? "CODE_12" = "242" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; complex cultivation patterns
    if gis:property-value ? "CODE_12" = "231" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; pastures
    if gis:property-value ? "CODE_12" = "222" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; fruit tress and berry plantations
    if gis:property-value ? "CODE_12" = "211" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; non irrigated arable land
    if gis:property-value ? "CODE_12" = "142" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; sport and leisure facilities
    if gis:property-value ? "CODE_12" = "141" [ gis:set-drawing-color 63  gis:fill ? 2.0] ;; green urban areas
    if gis:property-value ? "CODE_12" = "133" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; construction sites
    if gis:property-value ? "CODE_12" = "132" [ gis:set-drawing-color orange  gis:fill ? 2.0] ;; dump sites
    if gis:property-value ? "CODE_12" = "131" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; mineral extraction sites
    if gis:property-value ? "CODE_12" = "124" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; airports
    if gis:property-value ? "CODE_12" = "123" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; port areas
    if gis:property-value ? "CODE_12" = "122" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; road and rail networks
    if gis:property-value ? "CODE_12" = "121" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; industrial or commerical units
    if gis:property-value ? "CODE_12" = "112" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; discontinuous urban fabric
    if gis:property-value ? "CODE_12" = "111" [ gis:set-drawing-color grey  gis:fill ? 2.0] ;; continuous urban fabric
    ]

;; ask the patches to assume the landcover value for the vector that takes up most of the space over them
  gis:apply-coverage ireland "CODE_12" landcover
;##################
;; Group the Land Cover Data
;##################
set freshwater gis:find-range ireland "CODE_12" "411" "523" ;; include values for water features but none for ocean
set ocean gis:find-features ireland "CODE_12" "523"
set land gis:find-range ireland "CODE_12" "110" "334" ;; include values for water features but none for ocean


if foods? [
;##################
;; Freshwater Code
;##################

foreach freshwater
  [ foreach  gis:vertex-lists-of ?
    [foreach  ? ;; can add n-of x here to specify the number of food items produced per patch
      [ let location gis:location-of ?
        if not empty? location
        [ create-foods 1
          [ set xcor item 0 location
            set ycor item 1 location
            set shape "circle"
     set size 0.2
     set color orange
             ] ]
      ] ] ]

ask n-of n-freshfoods foods [set color pink]
ask foods with [color != pink][die]
;##################
;; Ocean Code
;##################
; ask patches with [landcover = "523"] [set pcolor blue]
ask n-of n-seafoods patches with [landcover = "523" and pcolor = yellow] [sprout-foods 1 [
  set shape "circle"
     set size 0.2
     set color pink
]
]

;##################
;; Land Code
;##################

foreach land
  [ foreach  gis:vertex-lists-of ?
    [foreach  ? ;; added n-of 10 here
      [ let location gis:location-of ?
        if not empty? location
        [ create-foods 1
          [ set xcor item 0 location
            set ycor item 1 location
            set shape "circle"
     set size 0.2
     set color blue
             ] ]
      ] ] ]

ask n-of n-landfoods foods [set color pink]
ask foods with [color != pink][die]
]
;##################
;; Scale the Area
;##################
;  gis:set-drawing-color blue - 1  gis:fill freshwater 1
  set patch-scale (item 1 gis:world-envelope - item 0 gis:world-envelope ) / world-width
;; check the size of the area
;; show patch-scale * world-width
;; show world-width

reset-ticks
end

;##########################################################################################
;; GO COMMANDS
;##########################################################################################
to go
   if ticks = day-length  [set day day + 1 create-next-day]

   ask nutrients [
;if ticks = day-length - 1 [die]
;check-water  ;; BD change 2
]

  ask gulls [
   ; face patch 0 16
   move
   forage
   excrete
   rtb
   territory
  ]



  if ticks = 1 [

  ]

 ; ask [count foods / 50] [ die]

  tick
end

;##########################################################################################
;; GULL COMMANDS
;##########################################################################################

to move
      set energy  energy  - 1
   ifelse color = white  [fd v]
    [fd v / 4]
      if random 600 = 1 ;; frequency of turn
  [ ifelse random 2 = 0 ;; 50:50 chance of left or right
    [ rt 30 ] ;; could add some variation to this with random-normal 45 5
    [ lt 30 ]]
end

to forage
  ifelse any? foods in-radius 0.825[
    set color orange
  if random 200 = 1
  [ ifelse random 2 = 0
    [ rt 30 ]
    [ lt 30 ]]]
  [set color white]
end

to excrete
if random excretion-rate < 57 [hatch-nutrients 1 [
      set color cyan
      set shape "circle"
      set size 0.2
      check-water]]  ;;BD change 3
end

 to rtb
  if energy <= 0 [
   face patch 0 0
    if patch-here = [0 0] [face patch 0 16]]
end

to territory
   while [[pcolor] of patch-here = white]
    [
      face min-one-of patches with [pcolor = blue] [ distance myself ]
      move
    ]
end

;##########################################################################################
;; NUTRIENT COMMANDS
;##########################################################################################
to check-water
 ; let estuaries gis:find-features ireland "CODE_12" "522" ;;BD change 1
  ; ask nutrients [   ;;BD change 4
  ifelse gis:intersects? freshwater self [
  set color red
  set fresh-nutrients fresh-nutrients + 1
  die
   ]
  [
  set color cyan
    set other-nutrients other-nutrients + 1
       die
  ]
   ;]
end
;##########################################################################################
;; RESET COMMANDS
;##########################################################################################

to create-next-day
  clear-links
  reset-ticks
  ask gulls [set energy 10800]
; ask nutrients [die]
  go
end
;##########################################################################################
;; END OF CODE
;##########################################################################################
;; lat long WGS84  to Irish Transverse Mercator Grid Co-ordinates
;; http://www.fieldenmaps.info/cconv/cconv_ie.html
@#$#@#$#@
GRAPHICS-WINDOW
210
10
860
681
80
80
4.0
1
10
1
1
1
0
1
1
1
-80
80
-80
80
0
0
1
ticks
30.0

BUTTON
5
14
109
47
NIL
setup-ireland
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
111
14
174
47
NIL
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

TEXTBOX
876
337
1026
365
Cork Harbour to Youghal Harbour	Gyleen (west)\n
11
0.0
1

INPUTBOX
18
214
173
274
excretion-rate
68000
1
0
Number

MONITOR
16
286
113
331
NIL
count nutrients
17
1
11

SLIDER
6
61
178
94
n-gulls
n-gulls
0
100
20
1
1
NIL
HORIZONTAL

INPUTBOX
18
104
173
164
day-length
68000
1
0
Number

TEXTBOX
31
173
181
201
gulls sleep for 5 hours so awake for 19 hours
11
0.0
1

MONITOR
120
286
177
331
NIL
day
17
1
11

INPUTBOX
20
341
175
401
v
0.0104
1
0
Number

MONITOR
29
419
157
464
NIL
fresh-nutrients
17
1
11

MONITOR
31
476
128
521
NIL
other-nutrients
17
1
11

SLIDER
12
535
184
568
n-freshfoods
n-freshfoods
0
100
20
1
1
NIL
HORIZONTAL

TEXTBOX
890
421
941
463
0.0104 v for 20 km model
11
0.0
1

SLIDER
14
573
186
606
n-seafoods
n-seafoods
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
14
613
186
646
n-landfoods
n-landfoods
0
100
0
1
1
NIL
HORIZONTAL

SWITCH
14
662
117
695
foods?
foods?
1
1
-1000

@#$#@#$#@
## Parameter estimates

patch is 1212 metres long so fd 1 will mean the bird moves 1212 metres per second
12.6 metres per second given by Flight Speeds of Birds in Relation to Energetics and Wind Directions, Tucker & Schmidt-Koenig
12.6 m/sec = 45.36 km/hr
1212/12.6 = 96
fd 0.0104 = 12.6 metres per second

Herring Gull sleeps for 5 hours
Amlaner & Ball (1983) A Synthesis of Sleep in Wild Birds

Herring gull: 3.1 defecations per hour, Hahn, Bauer & Klaassen 2007

## vision

Because the patch scale is greater than 1km I have to change the distance the bird can see. If I used the value 1 it would mean the bird could see 1212 metres as it stands.
If I want it to only see 1km I've to rescale as follows:

1212 = 100%
1000 = 82.5% of 1212, the 1000 here is for the 1km distance
1 x 82.5 = 0.825
0.825 is the value the bird can see 1km in the model
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

hawk
true
0
Polygon -7500403 true true 151 170 136 170 123 229 143 244 156 244 179 229 166 170
Polygon -16777216 true false 152 154 137 154 125 213 140 229 159 229 179 214 167 154
Polygon -7500403 true true 151 140 136 140 126 202 139 214 159 214 176 200 166 140
Polygon -16777216 true false 151 125 134 124 128 188 140 198 161 197 174 188 166 125
Polygon -7500403 true true 152 86 227 72 286 97 272 101 294 117 276 118 287 131 270 131 278 141 264 138 267 145 228 150 153 147
Polygon -7500403 true true 160 74 159 61 149 54 130 53 139 62 133 81 127 113 129 149 134 177 150 206 168 179 172 147 169 111
Circle -16777216 true false 144 55 7
Polygon -16777216 true false 129 53 135 58 139 54
Polygon -7500403 true true 148 86 73 72 14 97 28 101 6 117 24 118 13 131 30 131 22 141 36 138 33 145 72 150 147 147

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
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.1
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