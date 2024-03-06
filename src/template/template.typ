#let project(
  title: "",
  authors: (),
  date: datetime.today().display(),
  title-page-infos: [],
  bib: "../refs.yml",
  bib-urls: false,
  lang: "de",
  font: "Calibri",
  font-size: 1.1em,
  leading: 0.85em,
  heading-padding: 0.4em,
  numbering-skip-outline: true,
  body,
) = {

  // Set general document settings
  set document(author: authors, title: title)

  // Set text settings
  set text(font: font, lang: lang, size: font-size)
  set par(leading: leading)

  // Set heading style
  set heading(numbering: "1.1")
  show heading: it => {
    it
    v(heading-padding)
  }

  // Set citation style for refs
  import "cite.typ": *
  show ref: it => show_custom_ref(it)
  show cite.where(style: auto): it => show_custom_cite(it)

  // Title pager
  {
    text(1.1em, date)
    v(1.2em, weak: true)
    text(2em, weight: 700, title)

    // Authors
    pad(
      top: 0.7em,
      right: 20%,
      grid(
        columns: (1fr,) * calc.min(3, authors.len()),
        gutter: 1em,
        ..authors.map(author => align(start, strong(author))),
      ),
    )

    align(bottom)[#title-page-infos]

    pagebreak()
  }

  // Enable page numbering
  set page(numbering: if numbering-skip-outline { none } else { "1" })

  // Table of contents
  {
    outline(depth: 5, indent: true)
    pagebreak()
  }

  // Reset page numbering if necessary
  set page(numbering: "1")
  if numbering-skip-outline {
    counter(page).update(1)
  }

  // Main body
  {
    set par(justify: true)
    body
  }

  // Display the bibliography if any is given
  if bib != none {
    pagebreak()
    let title = if lang == "de" { "Literatur" } else { none }
    show bibliography: it => {
      set heading(numbering: "1.1")
      it
    }
    let style = if bib-urls {
      "cite_styles/main.csl"
    } else {
      "cite_styles/main-no-urls.csl"
    }
    bibliography(bib, title: title, style: style)
  }
}
