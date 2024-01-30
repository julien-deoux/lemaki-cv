open SimpleDom

%%raw(`import resume from './resume.json'`)
@val external resume: Resume.t = "resume"

%%raw(`import { marked } from 'marked'`)
@val @scope("marked") external parse: string => string = "parse"

let formatDate = dateStr => {
  dateStr
  ->Date.fromString
  ->Date.toLocaleDateStringWithLocaleAndOptions("en-GB", {month: #short, year: #numeric})
}

let formatDates = ((startDate, endDate)) => {
  switch (startDate, endDate) {
  | (None, None) => None
  | (None, Some(ed)) => Some(formatDate(ed))
  | (Some(sd), None) => Some(`${formatDate(sd)} - Now`)
  | (Some(sd), Some(ed)) => Some(`${formatDate(sd)} - ${formatDate(ed)}`)
  }
}

let trimUrl = url => {
  let regex = %re("/https?:\/\/(.*)/")
  let result = Re.exec(regex, url)
  let captures = Option.getOr(result, [])
  let capture = captures[1]
  Option.getOr(capture, "")
}

let createMainContact = (label, url) => {
  li([("class", "contact")], [a([("href", url)], [text(label)])])
}

let createWorkMetadata = (work: Resume.work) => {
  let name = Option.map(work.name, n => div([("class", "work__name")], [text(n)]))
  let position = Option.map(work.position, p => div([("class", "work__position")], [text(p)]))
  let dates =
    (work.startDate, work.endDate)
    ->formatDates
    ->Option.map(dates => div([("class", "work__dates")], [text(dates)]))
  div([("class", "section__column")], Array.filterMap([name, position, dates], x => x))
}

let createWorkSummary = (work: Resume.work) => {
  let summary = Option.map(work.summary, s => {
    let result = div([("class", "work__summary")], [])
    setInnerHTML(result, parse(s))
    result
  })
  div([("class", "section__column--wide")], Array.filterMap([summary], x => x))
}

let createWork = (work: Resume.work) => {
  div([("class", "section__content")], [createWorkMetadata(work), createWorkSummary(work)])
}

let createEducationMetadata = (education: Resume.education) => {
  let degree = Option.map(education.studyType, d =>
    div([("class", "education__degree")], [text(d)])
  )
  let institution = Option.map(education.institution, i =>
    div([("class", "education__institution")], [text(i)])
  )
  let area = Option.map(education.area, a => div([("class", "education__area")], [text(a)]))
  let dates =
    (education.startDate, education.endDate)
    ->formatDates
    ->Option.map(dates => div([("class", "education__dates")], [text(dates)]))
  div([("class", "section__column")], Array.filterMap([degree, institution, area, dates], x => x))
}

let createSkill = (skill: Resume.skill) => {
  let icon = Option.map(skill.icon, i => img([("class", "techno__icon"), ("src", i)], []))
  let name = Option.map(skill.name, n => span([("class", "techno__name")], [text(n)]))
  div([("class", "techno")], Array.filterMap([icon, name], x => x))
}

Option.forEach(resume.basics, basics => {
  Option.forEach(basics.name, name => {
    inject("name", text(name))
  })
  Option.forEach(basics.url, url => {
    inject("main_contacts", createMainContact(trimUrl(url), url))
  })
  Option.forEach(basics.email, email => {
    inject("main_contacts", createMainContact(email, `mailto:${email}`))
  })
  Option.forEach(basics.phone, phone => {
    inject(
      "secondary_contacts",
      li(
        [("class", "sec_contact")],
        [
          span([("class", "contact__icon fas fa-phone")], []),
          a([("class", "contact__link"), ("href", `tel:${phone}`)], [text(phone)]),
        ],
      ),
    )
  })
  Option.forEach(basics.profiles, profiles => {
    Array.forEach(
      profiles,
      ({network, url, username}) => {
        switch (network, url, username) {
        | (Some(n), Some(href), Some(un)) =>
          inject(
            "secondary_contacts",
            li(
              [("class", "sec_contact")],
              [
                span([("class", `contact__icon fab fa-${n}`)], []),
                a(
                  [("class", "contact__link"), ("href", href)],
                  [
                    text(
                      switch n {
                      | "linkedin" => `linkedin.com/in/${un}`
                      | "github" => `github.com/${un}`
                      | _ => un
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        | _ => ()
        }
      },
    )
  })
})

Option.forEach(resume.work, works => {
  Array.forEach(works, work => {
    inject("experience", createWork(work))
  })
})

Option.forEach(resume.education, educations => {
  Array.forEach(educations, education => {
    inject("education", createEducationMetadata(education))
  })
})

Option.forEach(resume.skills, skills => {
  Array.forEach(skills, skill => {
    inject("technos", createSkill(skill))
  })
})
