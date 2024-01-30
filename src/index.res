open SimpleDom

%%raw(`import resume from './resume.json'`)
@val external resume: Resume.t = "resume"

%%raw(`import { marked } from 'marked'`)
@val @scope("marked") external parse: string => string = "parse"

let unwrap = Option.forEach

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
  div([("class", "section__column")], Array.filterMap([name, position], x => x))
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
  let degree = Option.map(education.studyType, n =>
    div([("class", "education__degree")], [text(n)])
  )
  let institution = Option.map(education.institution, p =>
    div([("class", "education__institution")], [text(p)])
  )
  let area = Option.map(education.area, p => div([("class", "education__area")], [text(p)]))
  div([("class", "section__column")], Array.filterMap([degree, institution, area], x => x))
}

unwrap(resume.basics, basics => {
  unwrap(basics.name, name => {
    inject("name", text(name))
  })
  unwrap(basics.url, url => {
    inject("main_contacts", createMainContact(trimUrl(url), url))
  })
  unwrap(basics.email, email => {
    inject("main_contacts", createMainContact(email, `mailto:${email}`))
  })
})

unwrap(resume.work, works => {
  Array.forEach(works, work => {
    inject("experience", createWork(work))
  })
})

unwrap(resume.education, educations => {
  Array.forEach(educations, education => {
    inject("education", createEducationMetadata(education))
  })
})
