type location = {
  countryCode: option<string>,
  city: option<string>,
  region: option<string>,
  postalCode: option<string>,
  address: option<string>,
}

type profile = {
  network: option<string>,
  username: option<string>,
  url: option<string>,
}

type language = {
  language: option<string>,
  fluency: option<string>,
}

type basics = {
  name: option<string>,
  label: option<string>,
  email: option<string>,
  location: option<location>,
  phone: option<string>,
  profiles: option<array<profile>>,
  url: option<string>,
}

type work = {
  name: option<string>,
  description: option<string>,
  location: option<string>,
  startDate: option<string>,
  endDate: option<string>,
  position: option<string>,
  summary: option<string>,
}

type education = {
  institution: option<string>,
  url: option<string>,
  area: option<string>,
  studyType: option<string>,
  startDate: option<string>,
  endDate: option<string>,
}

type t = {
  basics: option<basics>,
  languages: option<array<language>>,
  work: option<array<work>>,
  education: option<array<education>>,
}
