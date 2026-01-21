#let colors = (
  BLACK : rgb(  0,   0,   0),
  WHITE : rgb(255, 255, 255),
  GREEN : rgb(200, 255, 200),
  RED   : rgb(255, 200, 200),
  BLUE  : rgb(200, 220, 255),
  YELLOW: rgb(255, 255, 200),
  ORANGE: rgb(255, 225, 200),
  PURPLE: rgb(220, 200, 255),
  ROSE  : rgb(255, 220, 240)
)

#let diagonal(body1, body2, width: auto, height: auto, inset: 5pt) = {
  table.cell(inset: 0pt,
    box(
    width: width,
    height: height)[
      #place(top+right,body1, dx: -inset, dy: inset)
      #place(bottom+left,body2, dx: inset, dy: -inset)
      #line(start: (0%,0%),end: (100%,100%),stroke: 0.5pt)
  ])
}
