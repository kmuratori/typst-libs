// TODO: complete the header/footer
// TODO: custom table, ...

#import "@local/util:0.1.0": current_h

#let conf(
  title       : (primary: "Untitled", secondary: none),
  fonts       : ("Linux Libertine", "DejaVu Sans"),
  date        : datetime.today(),
  authors     : ("Author No.1", "Author No.2"),
  supervisors : ("Supervisor No.1", "Supervisor No.2"),
  top_corners : ( left: none, right: none ),
  colors      : ( primary: rgb("#1e3a8a"), secondary: rgb("#6b7280") ),
  no_numbering: ( headings: false, pages: true ),
  // TODO: accept string values that specifu the
  // applied header/footer style: style1, style2
  // hf_style: "",
  no_header   : true,
  no_footer   : true,
  // TODO: Accept { hs: (1, 2), sep: "/" } OR integer
  h_level     : 2,
  oline       : (
    default: false,
    image  : false,
    table  : false,
    code   : false,
  ),
  body
) = {
  // FIXME: Not shown in zathura `:info`
  set document(
    title: title.primary,
    author: authors,
    date: date,
  )

  // Start config
  set page(
    paper: "a4",
    numbering: none,
    margin: (
      x: 2.5cm,
      y: 2.5cm,
    )
  )

  set text(font: fonts, size: 11pt)
  set quote(block: true, quotes: true)

  set heading(numbering: (..nums) => {
    if no_numbering.headings { none; return }
    let raw = nums.pos()
    let len = raw.len()
         if len == 1 { numbering("I.", raw.at(0))              }
    else if len == 2 { numbering("A.", raw.at(1))              }
    else if len == 3 { numbering("1.a.", raw.at(1), raw.at(2)) }
    else if len == 4 { numbering("i.", raw.last())             }
    else if len == 5 { none                                    }
    else if len == 6 { none                                    }
  })

  show heading: it => {
    if it.level == 1 {
      pagebreak()
      align(center)[ #text(size: 26pt, weight: "bold", fill: colors.primary, upper(it)) ]
      v(20pt)
    } else if it.level == 2 {
      text(size: 20pt, weight: "bold", fill: colors.primary, it)
      v(10pt)
    } else if it.level == 3 {
      text(size: 16pt, weight: "semibold", fill: colors.secondary, it)
      v(6pt)
    } else if it.level == 4 {
      text(size: 14pt, style: "italic", fill: colors.secondary, it)
      v(4pt)
    }
    else if it.level == 5 { text(size: 12pt, style: "italic", fill: colors.primary, it) }
    else if it.level == 6 { text(size: 12pt, style: "italic", fill: colors.primary, it) }
    else { it }
  }

  show link: it => underline(text(fill: colors.primary, style: "italic", it))

  set table(
    inset: 6pt,
    stroke: 0.5pt,
    fill: (x, y) => { if y == 0 or x == 0 { colors.primary.lighten(90%) } }
  )

  show raw.where(block: true): it => block(
    fill: colors.primary.lighten(95%),
    inset: 8pt,
    radius: 0pt,
    stroke: none,
    width: 100%,
    it,
  )
  // End config

  align(center)[
    #grid(
      columns: {
        let count = 0
        if top_corners.left  != none { count += 1 }
        if top_corners.right != none { count += 1 }
        range(count).map(_ => 1fr)
      },
      if top_corners.left  != none { [#top_corners.left]  } else { [] },
      if top_corners.right != none { [#top_corners.right] } else { [] },
    )

    #v(1cm)

    #text(22pt, weight: "bold")[ #title.primary ]
    
    #if "secondary" in title and title.secondary != none {
      text(18pt, fill: colors.primary, weight: "semibold")[ #title.secondary ]
    }

    #v(3cm)

    #text(13pt)[
      #grid(
        row-gutter: 10pt,
        columns: {
          let count = 0
          if authors.len() > 0     { count += 1 }
          if supervisors.len() > 0 { count += 1 }
          range(count).map(_ => 1fr)
        },

        if authors.len() == 1 { text(16pt)[*_Author_*] }
        else if authors.len() > 1 { text(16pt)[*_Authors_*] },

        if supervisors.len() == 1 { text(16pt)[*_Supervisor_*] }
        else if supervisors.len() > 1 { text(16pt)[*_Supervisors_*] },

        if authors.len() == 1 { [#authors.at(0)] }
        else if authors.len() > 1 { [#authors.join(",\n")] },

        if supervisors.len() == 1 { [#supervisors.at(0)] }
        else if supervisors.len() > 1 { [#supervisors.join(",\n")] },
      )
    ]

    #v(1fr)

    #date.display("[month repr:long] [day], [year]")
  ]

  context {
    if oline.default {
      outline(title: "contents")
    }
    if oline.image and query(figure.where(kind: image)).len() > 0 {
      outline(title: "figures", target: figure.where(kind: image))
    }
    if oline.table and query(figure.where(kind: table)).len() > 0 {
      outline(title: "tables", target: figure.where(kind: table))
    }
    if oline.code and query(figure.where(kind: raw)).len() > 0 {
      outline(title: "listings", target: figure.where(kind: raw))
    }
  }

  counter(page).update(0)

  set page(
    header: {
      if no_header { none }
      else {
        grid(
          // columns: (1fr, 1fr),
          columns: (1fr, 1fr, 1fr),
          align: (left, center, right),
          [ #upper(current_h(h_level)) ],
          [ #top_corners.left ],
          [ #context { [ #counter(page).display() / #counter(page).final().last() ] } ],
        )
      }
    },
  )

  body
}
