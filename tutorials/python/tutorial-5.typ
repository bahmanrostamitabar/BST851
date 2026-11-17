// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)
#import "@preview/fontawesome:0.5.0": *

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
)

#show: doc => article(
  title: [Tutorial 5: Data Wrangling Tutorial --- Walmart Weekly Sales],
  authors: (
    ( name: [Bahman Rostami-Tabar],
      affiliation: [Professor, Director, Data Lab for Social Godo Reserach Group, Cardiff Business School],
      email: [] ),
    ( name: [Udeshi (Merennage) Salgado],
      affiliation: [PhD student, Cardiff Business School],
      email: [] ),
    ( name: [Mustafa Aslan],
      affiliation: [PhD student, Cardiff Business School],
      email: [] ),
    ),
  date: [2025-10-23],
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

#block[
```r
library(tidyverse)
library(lubridate)
library(janitor)
library(tsibble)
library(here)
walmart_raw <- readr::read_csv(here("data/walmart.csv")) |> janitor::clean_names()
```

]
= Overview
<overview>
In this hands-on tutorial, you'll practice core #strong[tidyverse] data-wrangling skills on a real retail dataset: #strong[Walmart weekly sales];.

We will work through three tiers of practice:

- #strong[Section 1 --- Run-only:] complete code you can run to reproduce plots and analyses. \
- #strong[Section 2 --- Fill-in-the-blanks:] partially complete code with `???` for you to replace. \
- #strong[Section 3 --- No code (prompts):] questions only, so you write the code from scratch.

== Learning objectives
<learning-objectives>
By the end of this tutorial, you will be able to:

- filter/select/arrange rows and columns
- count and summarise with `group_by()` + `summarize()`
- create new variables with `mutate()`
- reshape with `pivot_longer()` / `pivot_wider()`
- join multiple datasets using `join_` funtions

We'll use `readr` to load #strong[walmart.csv] and a short cleaning step to standardise names and parse dates.

= Dataset
<dataset>
The Walmart dataset contains weekly sales at the store level along with contextual features. Each observation corresponds to a #strong[store--week] pair, enabling both cross-sectional comparison and time-series exploration.

#strong[Columns:]

- `Store` --- store identifier (integer) \
- `Date` --- week ending date (string like `05/02/2010`) \
- `Weekly_Sales` --- weekly sales amount (numeric, dollars) \
- `Holiday_Flag` --- 1 if the week includes public holiday, else 0 \
- `Temperature` --- average temperature for the week (Fahrenheit) \
- `Fuel_Price` --- average fuel price in the region (dollars/gallon)
- `consumer price index` --- CPI value in the rgion, a measure of inflation
- `Unemployment` --- unemployment rate

#block[
#callout(
body: 
[
`Date` in `wallmaer.csv` appears in #strong[day/month/year] format in the csv file. We'll parse it using #strong[lubridate];, which is a package in #strong[tidyverse] to work with date and time data.

]
, 
title: 
[
Tip
]
, 
background_color: 
rgb("#ccf1e3")
, 
icon_color: 
rgb("#00A047")
, 
icon: 
fa-lightbulb()
, 
body_background_color: 
white
)
]
= Section 1-Run the code
<section-1-run-the-code>
#block[
```r
walmart_raw
```

]
check the data structure, and make sure it's tibble, then check data types!

#block[
#callout(
body: 
[
Look at the data type unde column date, it says `chr`, whcih is not a correct data tyep! we have to change it, maybe to a date, let's start with that!

]
, 
title: 
[
Warning
]
, 
background_color: 
rgb("#fcefdc")
, 
icon_color: 
rgb("#EB9113")
, 
icon: 
fa-exclamation-triangle()
, 
body_background_color: 
white
)
]
#block[
```r
walmart_correct_date <- walmart_raw |> mutate(date = lubridate::dmy(date))
```

]
The date in column `date`, are 7 days apart, so basically this column represents weeks of the year, let'sconvert it to that:

#block[
```r
walmart_correct_week <- walmart_correct_date |> 
  mutate(week = tsibble::yearweek(date))
```

]
holiday\_flag variable valeus are also 0, or 1, to make it more meaningful we change them to "Holiday", "Non-holiday". Todo that, we have to use `if_else()`! This fucntion is useful for one condition:

#block[
```r
walmart <- walmart_correct_week |> mutate(holiday_flag = if_else(holiday_flag == 1, "Holiday", "Non-holiday"))
```

]
What if I have multiple condition, for example which fcuntion I can use if I create a new variable whcih take `temperature` variable and categrise it into cold, hot, and mild?

Now, let's pick the weeks that are #strong[holiday weeks];:

#block[
```r
walmart |> 
  filter(holiday_flag == "Holiday")
```

]
From the gapminder data, Keep only `store`, `date`, `weekly_sales`, and `temperature`, and save it ina new naem , walmart\_selected\`

#block[
```r
walmart |> select(store, date,weekly_sales,temperature)
```

]
Remove the columns `date` and `unemployment`.

#block[
```r
walmart |> 
  select(-date, -unemployment)
```

]
Now, let,s reorder the columns, I want to see store , date, week, weekly\_sales, and then everyhting as they are:

#block[
```r
walmart |> select(store, date, week, weekly_sales, everything())
```

]
Create new column to extract , year, quarter, and month in seperate columns!

#block[
```r
walmart |> mutate(year = lubridate::year(date),
                  quarter = lubridate::quarter(date),
                  month = lubridate::month(date, label = TRUE))
```

]
Sort by #strong[weekly\_sales] (smallest → largest).

#block[
```r
walmart |> arrange(weekly_sales) 
```

]
Now sort by #strong[weekly\_sales] in #strong[descending] order, breaking ties by #strong[store] (ascending).

#block[
```r
walmart |> arrange(desc(weekly_sales), store)
```

]
Counts by #strong[year] and #strong[is\_holiday];:

#block[
```r
walmart |> count(year, holiday_flag)
```

]
= Sedtion 2: filling blank
<sedtion-2-filling-blank>
Create #strong[sales\_in\_millions] (`weekly_sales / 1e6`) and #strong[temp\_c] from Fahrenheit. \
Recall: °C = (°F − 32) × 5/9.

#block[
```r
walmart |> 
  mutate(
    sales_in_millions = ??? / 1e6,
    temp_c = (??? - 32) * 5/9
  ) |> 
  select(store, date, weekly_sales, sales_in_millions, temp_c)
```

]
Add an indicator for #strong[hot weeks];: temperature ≥ 90°F, and then count by store.

#block[
```r
walmart |> 
  mutate(heat_flag = ???(temperature >= 90, "hot", "not_hot")
        ) |> 
  ???(store, heat_flag) |> 
  arrange()
```

]
Calculate, average, minimum, and maximum weekly sales #strong[by store];, what `na.rm = TRUE` means?

#block[
```r
walmart |> 
  ???(store) |> 
  ???(mean_sales = mean(weekly_sales, na.rm = TRUE,
      min_sales = min(weekly_sales, na.rm = TRUE),
      max_sales = max(weekly_sales, na.rm = TRUE)))
```

]
`slice()` lets you index rows by their (integer) locations.

#block[
```r
walmart %>% slice(5:10)
```

]
Filter away missing values before summarising (for example, weekly\_sales and temperature).

#block[
```r
walmart |> 
  filter(!is.na(weekly_sales), !is.na(temperature)) |> 
  group_by(year) |> 
  summarize(
    mean_sales = mean(weekly_sales),
    mean_temp  = mean(temperature)
  )
```

]
Can you use `drop_na` when you have missing values? what it does?

= Section3: No code
<section3-no-code>
+ For each #strong[store];, find the #strong[top 3] weekly sales weeks (date + amount).

+ We want to calculate the total sales for all walmart stores based on the temperatures, wetehr it;s cold, mild, hot!

+ Compute #strong[year-over-year (%)] change in average weekly sales per store.

+ Does higher #strong[fuel\_price] correspond to higher or lower #strong[weekly\_sales];? Explore with grouped summaries.

#emph[Tip:] You may find `slice_max()`, `if_else insetad`, `arrange()`, `lag()`, and `mutate()` handy.
