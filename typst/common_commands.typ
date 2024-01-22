#let implies = $arrow.r.double.long$

#let tab = str("    ")

#let linkbox(
    lab,
    fill: maroon,
    color: white,
    outset: 3pt,
    inset: 3pt,
    radius: 5pt,
    body,
) = {
    link(
        label(lab),
    )[
        #box(
            fill: fill,
            outset: outset,
            inset: inset,
            radius: radius,
        )[
            #text(
                fill: color,
                size: 0.75em,
            )[#body]
        ]
    ]
}

#let stylebox(
  color_bar: gray,
  color_fill: gray,
  body
) = {
  block(
    stroke: (left: color_bar + 4pt,),
    fill: color_fill.lighten(80%),
    width: 100%,
    // inset: (left: 10pt, right: 0pt, rest: 4pt,),
    inset: (10pt),
    breakable: true,
  )[
    #body
  ]
}