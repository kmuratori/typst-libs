# local typst libs


## report

code starter:

```typ
// include the lib
// #import "@local/report:0.1.0": conf
#show: conf.with(
  authors: (),
  supervisors: (),
  title: (
    primary: "",
    secondary: "",
  ),
  top_corners: (
    left:  image("path/to/image", width: 25%),
    right: none,
  ),
  oline : (
    default: true,
    image  : true,
    table  : true,
    code   : true,
  ),
  no_numbering: (headings: false, pages: true),
  no_header: false,
  no_footer: false,
  h_level: 2,
)
```

