import cnpj/cnpj
import gleam/list
import gleam/regexp
import gleeunit/should
import utils/format

pub fn cnpj_validate_same_digits_test() {
  cnpj.validate("00.000.000/0000-00") |> should.be_false
  cnpj.validate("11.111.111/1111-11") |> should.be_false
  cnpj.validate("22.222.222/2222-22") |> should.be_false
  cnpj.validate("33.333.333/3333-33") |> should.be_false
  cnpj.validate("44.444.444/4444-44") |> should.be_false
  cnpj.validate("55.555.555/5555-55") |> should.be_false
  cnpj.validate("66.666.666/6666-66") |> should.be_false
  cnpj.validate("77.777.777/7777-77") |> should.be_false
  cnpj.validate("88.888.888/8888-88") |> should.be_false
  cnpj.validate("99.999.999/9999-99") |> should.be_false
}

pub fn validate_cnjp_valid_cnpjs_test() {
  valid_cnpj_list()
  |> list.each(fn(cnpj) { cnpj.validate(cnpj) |> should.be_true })
}

pub fn validate_cnpj_with_additional_characters() {
  cnpj.validate("38.148.065/0001-51 ") |> should.be_true
  cnpj.validate("   38.148.0650001-51     ") |> should.be_true
  cnpj.validate("38148065000151") |> should.be_true
}

pub fn validate_cnpj_with_invalid_characters() {
  cnpj.validate("38.148.065/0001-5a") |> should.be_false
  cnpj.validate("38.148.065/0001-5") |> should.be_false
  cnpj.validate("38.148.065/0001-") |> should.be_false
  cnpj.validate("38.148.065/0001-") |> should.be_false
  cnpj.validate("38.148.065/0001-5a") |> should.be_false
  cnpj.validate("38.148.065/0001-5") |> should.be_false
  cnpj.validate("38.148.065/0001-") |> should.be_false
  cnpj.validate("38.148.065/0001-") |> should.be_false
  cnpj.validate("38.148.065/0001-5a") |> should.be_false
  cnpj.validate("38.148.065/0001-5") |> should.be_false
  cnpj.validate("38.148.065/0001-") |> should.be_false
  cnpj.validate("38.148.065/0001-") |> should.be_false
}

pub fn validate_cnpj_invalid_cnpjs_test() {
  invalid_cnpj_list()
  |> list.each(fn(cnpj) { cnpj.validate(cnpj) |> should.be_false })
}

pub fn strict_validation_valid_cnpjs_test() {
  let invalid_cnpj_list = [
    " 38.148.065/0001 -51", "*11.222.333/000181", "65534002/0001-06  ",
    " 38148065000151 ", " 65.173.72/10001-44", "64.-95 ",
  ]
  valid_cnpj_list()
  |> list.each(fn(cnpj) { cnpj.strict_validate(cnpj) |> should.be_true })

  invalid_cnpj_list
  |> list.each(fn(cnpj) { cnpj.strict_validate(cnpj) |> should.be_false })
}

pub fn strict_validate_numeric_cnpj_test() {
  // Valid formatted numeric CNPJs
  cnpj.strict_validate("38.148.065/0001-51") |> should.be_true
  cnpj.strict_validate("11.222.333/0001-81") |> should.be_true

  // Valid unformatted numeric CNPJs
  cnpj.strict_validate("38148065000151") |> should.be_true
  cnpj.strict_validate("11222333000181") |> should.be_true

  // Valid: mixed formats (regex allows optional separators)
  cnpj.strict_validate("38148065/0001-51") |> should.be_true
  cnpj.strict_validate("38.148.065000151") |> should.be_true

  // Invalid: spaces around
  cnpj.strict_validate(" 38.148.065/0001-51 ") |> should.be_false
  cnpj.strict_validate(" 38148065000151 ") |> should.be_false

  // Invalid: wrong number of digits
  cnpj.strict_validate("3814806500015") |> should.be_false
  cnpj.strict_validate("381480650001511") |> should.be_false

  // Invalid: letters in numeric CNPJ
  cnpj.strict_validate("3814806500A151") |> should.be_false
}

pub fn generate_unformatted_cnpj_test() {
  list.range(1, 100_000)
  |> list.each(fn(_) {
    let cnpj_string = cnpj.generate(False)
    cnpj.validate(cnpj_string) |> should.be_true

    regexp.check(format.unformatted_cnpj_regex(), cnpj_string) |> should.be_true
  })
}

pub fn generate_formatted_cnpj_test() {
  list.range(1, 100_000)
  |> list.each(fn(_) {
    let cnpj_string = cnpj.generate(True)
    cnpj.validate(cnpj_string) |> should.be_true

    regexp.check(format.formatted_cnpj_regex(), cnpj_string) |> should.be_true
  })
}

pub fn strip_cnpj_test() {
  cnpj.strip("38.148.065/0001-51") |> should.equal(Ok("38148065000151"))
  cnpj.strip("38148065000151") |> should.equal(Ok("38148065000151"))
  cnpj.strip("38.148.065/0001-51") |> should.equal(Ok("38148065000151"))
  cnpj.strip("38.148.065/0001-51") |> should.equal(Ok("38148065000151"))
  cnpj.strip(" 38.148.065/0001-51 ") |> should.equal(Ok("38148065000151"))
  cnpj.strip(" 38.148.065/0001-51") |> should.equal(Ok("38148065000151"))
  cnpj.strip("38.148.065/0001-51 ") |> should.equal(Ok("38148065000151"))
  cnpj.strip("38.148.065*0001-51") |> should.equal(Ok("38148065000151"))
  cnpj.strip("38*148;065/0001-51") |> should.equal(Ok("38148065000151"))
  cnpj.strip("38..148..065//0001-51") |> should.equal(Ok("38148065000151"))

  [
    "38148065000151123", "38165000151", "3814806500015", "38.148.065/0001-52",
    "", "  ",
  ]
  |> list.each(fn(cnpj) {
    cnpj.strip(cnpj) |> should.equal(Error("Invalid CNPJ"))
  })
}

pub fn strip_alphanumeric_cnpj_test() {
  cnpj.strip("12.ABC.345/01DE-35") |> should.equal(Ok("12ABC34501DE35"))
  cnpj.strip("12ABC34501DE35") |> should.equal(Ok("12ABC34501DE35"))
  cnpj.strip(" 12.ABC.345/01DE-35 ") |> should.equal(Ok("12ABC34501DE35"))
  cnpj.strip("12.abc.345/01de-35") |> should.equal(Ok("12ABC34501DE35"))
  cnpj.strip("AA.345.678/0001-14") |> should.equal(Ok("AA345678000114"))
  cnpj.strip("AA345678000A29") |> should.equal(Ok("AA345678000A29"))
}

pub fn format_cnpj_test() {
  cnpj.format("38148065000151") |> should.equal(Ok("38.148.065/0001-51"))
  cnpj.format("38.148.065/0001-51") |> should.equal(Ok("38.148.065/0001-51"))
  cnpj.format("38148065/0001-51") |> should.equal(Ok("38.148.065/0001-51"))
  cnpj.format("38.148.0650001-51") |> should.equal(Ok("38.148.065/0001-51"))
  cnpj.format(" 38.148.065/0001-51 ") |> should.equal(Ok("38.148.065/0001-51"))
  cnpj.format(" 38.148.065/0001-51") |> should.equal(Ok("38.148.065/0001-51"))
  cnpj.format("38.148.065/0001-51 ") |> should.equal(Ok("38.148.065/0001-51"))

  ["38148065000151123", "38165000151", "3814806500015", "", "  "]
  |> list.each(fn(cnpj) {
    cnpj.format(cnpj) |> should.equal(Error("Invalid CNPJ"))
  })
}

pub fn format_alphanumeric_cnpj_test() {
  cnpj.format("12ABC34501DE35") |> should.equal(Ok("12.ABC.345/01DE-35"))
  cnpj.format("12.ABC.345/01DE-35") |> should.equal(Ok("12.ABC.345/01DE-35"))
  cnpj.format("12abc34501de35") |> should.equal(Ok("12.ABC.345/01DE-35"))
  cnpj.format("AA345678000114") |> should.equal(Ok("AA.345.678/0001-14"))
  cnpj.format("AA.345.678/0001-14") |> should.equal(Ok("AA.345.678/0001-14"))
  cnpj.format(" AA345678000114 ") |> should.equal(Ok("AA.345.678/0001-14"))
  cnpj.format("aa345678000114") |> should.equal(Ok("AA.345.678/0001-14"))
}

fn invalid_cnpj_list() {
  [
    "38.148.065/0001-52", "11.222.333/0001-82", "65.534.002/0001-07",
    "65.173.672/0001-45", "64.107.624/0001-96", "72.543.887/0001-76",
    "23.404.607/0001-33", "82.172.132/0001-66", "56.553.212/0001-51",
    "35.800.170/0001-36", "40.861.042/0001-32", "87.704.540/0001-35",
    "34.058.852/0001-52", "75.110.204/0001-85", "72.405.663/0001-06",
    "13.452.570/0001-65", "00.563.411/0001-96", "78.165.845/0001-25",
    "47.888.486/0001-01", "01.534.782/0001-02", "54.428.862/0001-40",
    "64.303.288/0001-57", "74.430.015/0001-27", "06.148.337/0001-28",
    "07.050.133/0001-12", "85.625.704/0001-03", "82.435.463/0001-41",
    "46.636.473/0001-81", "38.738.166/0001-83", "11.164.614/0001-26",
    "38.433.015/0001-17", "24.360.128/0001-25", "47.858.008/0001-58",
    "70.630.366/0001-21", "02.471.451/0001-33", "64.040.061/0001-66",
    "74.105.132/0001-15", "75.180.438/0001-07", "03.583.165/0001-22",
  ]
}

pub fn validate_alphanumeric_cnpj_test() {
  cnpj.validate("12ABC34501DE35") |> should.be_true
  cnpj.validate("12.ABC.345/01DE-35") |> should.be_true
  cnpj.validate("38.148.065/0001-51") |> should.be_true
  cnpj.validate("38148065000151") |> should.be_true
}

pub fn validate_invalid_alphanumeric_cnpj_test() {
  cnpj.validate("12ABC34501DE34") |> should.be_false
  cnpj.validate("12ABC34501DE36") |> should.be_false
  cnpj.validate("12ABC34501DE3") |> should.be_false
  cnpj.validate("12ABC34501DE356") |> should.be_false
}

pub fn validate_receita_federal_examples_test() {
  valid_alphanumeric_cnpj_list()
  |> list.each(fn(cnpj_str) { cnpj.validate(cnpj_str) |> should.be_true })
}

pub fn validate_invalid_receita_federal_examples_test() {
  invalid_alphanumeric_cnpj_list()
  |> list.each(fn(cnpj_str) { cnpj.validate(cnpj_str) |> should.be_false })
}

fn valid_alphanumeric_cnpj_list() {
  [
    "12.ABC.345/01DE-35", "12ABC34501DE35", "AA345678000114",
    "AA.345.678/0001-14", "AA345678000A29", "AA.345.678/000A-29",
    "12345678000A08", "12.345.678/000A-08",
  ]
}

fn invalid_alphanumeric_cnpj_list() {
  [
    "AA345678000113", "AA345678000115", "AA345678000A28", "AA345678000A30",
    "12345678000A07", "12345678000A09", "12ABC34501DE34", "12ABC34501DE36",
    "AAAAAAAAAAAAAA", "AA.AAA.AAA/AAAA-AA", "BBBBBBBBBBBBBB",
  ]
}

pub fn cnpj_validate_empty_string_test() {
  cnpj.validate("") |> should.be_false
  cnpj.strict_validate("") |> should.be_false
}

pub fn cnpj_validate_only_whitespace_test() {
  cnpj.validate("   ") |> should.be_false
  cnpj.validate("\t") |> should.be_false
  cnpj.validate("\n") |> should.be_false
  cnpj.validate(" \t\n ") |> should.be_false
}

pub fn cnpj_validate_with_tabs_test() {
  cnpj.validate("38\t148\t065\t0001\t51") |> should.be_true
  cnpj.validate("\t38.148.065/0001-51\t") |> should.be_true
}

pub fn cnpj_validate_with_multiple_spaces_test() {
  cnpj.validate("38   148   065   0001   51") |> should.be_true
  cnpj.validate("38.148.065/0001-51     ") |> should.be_true
  cnpj.validate("     38.148.065/0001-51") |> should.be_true
}

pub fn cnpj_validate_with_newlines_test() {
  cnpj.validate("38.148.065/0001-51\n") |> should.be_true
  cnpj.validate("\n38.148.065/0001-51") |> should.be_true
}

pub fn cnpj_validate_with_leading_zeros_test() {
  cnpj.validate("00.217.202/0001-90") |> should.be_true
  cnpj.validate("00217202000190") |> should.be_true
  cnpj.validate("00.163.616/0001-83") |> should.be_true
}

pub fn cnpj_validate_extremely_long_string_test() {
  cnpj.validate("38.148.065/0001-51000000000000000000") |> should.be_false
  cnpj.validate("38148065000151000000000000000000") |> should.be_false
}

pub fn cnpj_validate_only_special_characters_test() {
  cnpj.validate(".-./--") |> should.be_false
  cnpj.validate("...///---...") |> should.be_false
  cnpj.validate("**************") |> should.be_false
}

pub fn cnpj_validate_mixed_valid_invalid_chars_test() {
  cnpj.validate("38@148#065$0001%51") |> should.be_true
  cnpj.validate("38*148&065^0001!51") |> should.be_true
}

pub fn cnpj_validate_unicode_characters_test() {
  cnpj.validate("38€148£065¥0001₹51") |> should.be_true
  cnpj.validate("38🎉148🎈065🎊0001🎁51") |> should.be_true
}

pub fn cnpj_validate_almost_valid_cnpj_test() {
  cnpj.validate("38.148.065/0001-52") |> should.be_false
  cnpj.validate("38.148.065/0001-50") |> should.be_false
  cnpj.validate("38.148.065/0000-51") |> should.be_false
}

pub fn cnpj_validate_single_char_test() {
  cnpj.validate("1") |> should.be_false
  cnpj.validate("a") |> should.be_false
}

pub fn cnpj_validate_exact_13_digits_test() {
  cnpj.validate("3814806500015") |> should.be_false
}

pub fn cnpj_validate_exact_15_digits_test() {
  cnpj.validate("381480650001511") |> should.be_false
}

pub fn cnpj_strip_empty_string_test() {
  cnpj.strip("") |> should.equal(Error("Invalid CNPJ"))
  cnpj.strip("   ") |> should.equal(Error("Invalid CNPJ"))
}

pub fn cnpj_format_empty_string_test() {
  cnpj.format("") |> should.equal(Error("Invalid CNPJ"))
  cnpj.format("   ") |> should.equal(Error("Invalid CNPJ"))
}

pub fn cnpj_strip_with_only_special_chars_test() {
  cnpj.strip(".-./--") |> should.equal(Error("Invalid CNPJ"))
  cnpj.strip("***") |> should.equal(Error("Invalid CNPJ"))
}

pub fn cnpj_format_with_only_special_chars_test() {
  cnpj.format(".-./--") |> should.equal(Error("Invalid CNPJ"))
  cnpj.format("***") |> should.equal(Error("Invalid CNPJ"))
}

pub fn validate_alphanumeric_with_lowercase_test() {
  cnpj.validate("12abc34501de35") |> should.be_true
  cnpj.validate("12.abc.345/01de-35") |> should.be_true
}

pub fn validate_alphanumeric_mixed_case_test() {
  cnpj.validate("12AbC34501De35") |> should.be_true
  cnpj.validate("aA345678000114") |> should.be_true
}

pub fn validate_alphanumeric_with_spaces_test() {
  cnpj.validate("  12ABC34501DE35  ") |> should.be_true
  cnpj.validate("12 ABC 345 01 DE 35") |> should.be_true
}

pub fn validate_alphanumeric_with_special_chars_test() {
  cnpj.validate("12*ABC*345*01DE*35") |> should.be_true
  cnpj.validate("AA@345@678@000@114") |> should.be_true
}

pub fn validate_alphanumeric_only_letters_test() {
  cnpj.validate("ABCDEFGHIJKLMN") |> should.be_false
  cnpj.validate("ABCDEFGHIJ0000") |> should.be_false
}

pub fn validate_alphanumeric_invalid_dv_test() {
  cnpj.validate("12ABC34501DE99") |> should.be_false
  cnpj.validate("12ABC34501DE00") |> should.be_false
}

pub fn validate_alphanumeric_too_short_test() {
  cnpj.validate("12ABC345") |> should.be_false
  cnpj.validate("AA34567800") |> should.be_false
}

pub fn validate_alphanumeric_too_long_test() {
  cnpj.validate("12ABC34501DE35123") |> should.be_false
  cnpj.validate("AA345678000114123") |> should.be_false
}

pub fn validate_alphanumeric_with_tabs_test() {
  cnpj.validate("12\tABC\t345\t01DE\t35") |> should.be_true
  cnpj.validate("\t12ABC34501DE35\t") |> should.be_true
  cnpj.validate("AA\t345\t678\t000\t114") |> should.be_true
}

pub fn validate_alphanumeric_with_newlines_test() {
  cnpj.validate("12ABC34501DE35\n") |> should.be_true
  cnpj.validate("\n12ABC34501DE35") |> should.be_true
  cnpj.validate("AA345678000114\n\n") |> should.be_true
}

pub fn validate_alphanumeric_with_multiple_spaces_test() {
  cnpj.validate("12   ABC   345   01DE   35") |> should.be_true
  cnpj.validate("AA   345   678   000   114") |> should.be_true
  cnpj.validate("     12ABC34501DE35     ") |> should.be_true
}

pub fn validate_alphanumeric_with_unicode_test() {
  cnpj.validate("12€ABC€345€01DE€35") |> should.be_true
  cnpj.validate("AA🎉345🎈678🎊000🎁114") |> should.be_true
}

pub fn strict_validate_alphanumeric_test() {
  // Valid formatted alphanumeric CNPJs
  cnpj.strict_validate("12.ABC.345/01DE-35") |> should.be_true
  cnpj.strict_validate("AA.345.678/0001-14") |> should.be_true
  cnpj.strict_validate("AA.345.678/000A-29") |> should.be_true

  // Valid unformatted alphanumeric CNPJs
  cnpj.strict_validate("12ABC34501DE35") |> should.be_true
  cnpj.strict_validate("AA345678000114") |> should.be_true
  cnpj.strict_validate("AA345678000A29") |> should.be_true

  // Valid with lowercase letters (converted to uppercase)
  cnpj.strict_validate("12.abc.345/01de-35") |> should.be_true
  cnpj.strict_validate("aa345678000114") |> should.be_true

  // Invalid: spaces around
  cnpj.strict_validate(" 12.ABC.345/01DE-35 ") |> should.be_false
  cnpj.strict_validate(" AA345678000114 ") |> should.be_false

  // Invalid: wrong special characters
  cnpj.strict_validate("12*ABC*345*01DE*35") |> should.be_false
  cnpj.strict_validate("12 ABC 345 01DE 35") |> should.be_false

  // Invalid: wrong format
  cnpj.strict_validate("12ABC34501DE-35") |> should.be_false
  cnpj.strict_validate("12.ABC34501DE35") |> should.be_false
}

pub fn validate_alphanumeric_invalid_check_digits_test() {
  cnpj.validate("12ABC34501DE34") |> should.be_false
  cnpj.validate("12ABC34501DE36") |> should.be_false
  cnpj.validate("AA345678000113") |> should.be_false
  cnpj.validate("AA345678000115") |> should.be_false
  cnpj.validate("12345678000A07") |> should.be_false
  cnpj.validate("12345678000A09") |> should.be_false
}

pub fn strip_alphanumeric_edge_cases_test() {
  cnpj.strip("12.abc.345/01de-35") |> should.equal(Ok("12ABC34501DE35"))
  cnpj.strip("Aa.345.678/0001-14") |> should.equal(Ok("AA345678000114"))
  cnpj.strip("   AA345678000114   ") |> should.equal(Ok("AA345678000114"))
  cnpj.strip("12@ABC@345@01DE@35") |> should.equal(Ok("12ABC34501DE35"))
}

pub fn format_alphanumeric_edge_cases_test() {
  cnpj.format("12abc34501de35") |> should.equal(Ok("12.ABC.345/01DE-35"))
  cnpj.format("aa345678000114") |> should.equal(Ok("AA.345.678/0001-14"))
  cnpj.format("AA345678000A29") |> should.equal(Ok("AA.345.678/000A-29"))
}

pub fn validate_alphanumeric_same_characters_test() {
  cnpj.validate("AAAAAAAAAAAAAA") |> should.be_false
  cnpj.validate("AA.AAA.AAA/AAAA-AA") |> should.be_false
  cnpj.validate("BBBBBBBBBBBBBB") |> should.be_false
  cnpj.validate("11111111111111") |> should.be_false
}

pub fn validate_alphanumeric_mixed_format_test() {
  cnpj.validate("12.ABC34501DE-35") |> should.be_true
  cnpj.validate("12ABC.345/01DE35") |> should.be_true
  cnpj.validate("AA345.678.0001.14") |> should.be_true
}

fn valid_cnpj_list() {
  [
    "38.148.065/0001-51", "11.222.333/0001-81", "65.534.002/0001-06",
    "65.173.672/0001-44", "64.107.624/0001-95", "72.543.887/0001-75",
    "23.404.607/0001-32", "82.172.132/0001-65", "56.553.212/0001-50",
    "35.800.170/0001-35", "40.861.042/0001-31", "87.704.540/0001-34",
    "34.058.852/0001-51", "75.110.204/0001-84", "72.405.663/0001-05",
    "13.452.570/0001-64", "00.563.411/0001-95", "78.165.845/0001-24",
    "47.888.486/0001-00", "01.534.782/0001-01", "54.428.862/0001-49",
    "64.303.288/0001-56", "74.430.015/0001-26", "06.148.337/0001-27",
    "07.050.133/0001-11", "85.625.704/0001-02", "82.435.463/0001-40",
    "46.636.473/0001-80", "38.738.166/0001-82", "11.164.614/0001-25",
    "38.433.015/0001-16", "24.360.128/0001-24", "47.858.008/0001-57",
    "70.630.366/0001-20", "02.471.451/0001-32", "64.040.061/0001-65",
    "74.105.132/0001-14", "75.180.438/0001-06", "03.583.165/0001-21",
    "00.163.616/0001-83", "41.444.823/0001-93", "22.171.154/0001-89",
    "75.711.045/0001-73", "24.580.224/0001-88", "78.341.274/0001-31",
    "36.015.616/0001-83", "37.287.378/0001-28", "33.780.704/0001-83",
    "84.201.646/0001-27", "05.572.344/0001-99", "42.186.840/0001-30",
    "82.443.565/0001-08", "27.807.573/0001-88", "42.838.281/0001-04",
    "71.075.357/0001-87", "65.400.862/0001-57", "21.057.345/0001-51",
    "37.540.158/0001-64", "13.472.304/0001-01", "04.365.652/0001-80",
    "48.440.805/0001-82", "85.081.815/0001-03", "65.104.114/0001-27",
    "52.202.153/0001-15", "45.327.460/0001-67", "55.476.126/0001-29",
    "71.250.681/0001-94", "56.445.187/0001-91", "85.710.415/0001-01",
    "28.437.404/0001-66", "15.140.685/0001-49", "87.477.301/0001-99",
    "64.046.653/0001-94", "51.120.180/0001-86", "60.215.574/0001-09",
    "31.202.426/0001-51", "17.038.282/0001-19", "04.778.201/0001-75",
    "41.521.173/0001-32", "23.573.750/0001-58", "74.721.458/0001-76",
    "15.617.734/0001-91", "26.635.762/0001-58", "66.781.424/0001-49",
    "50.837.604/0001-65", "70.004.101/0001-16", "20.561.585/0001-26",
    "13.213.837/0001-60", "15.536.024/0001-37", "73.682.683/0001-88",
    "78.238.625/0001-83", "04.165.122/0001-99", "76.370.220/0001-79",
    "30.784.714/0001-07", "64.786.050/0001-29", "76.551.375/0001-01",
    "05.457.400/0001-44", "25.866.548/0001-40", "24.328.216/0001-49",
    "03.278.787/0001-46", "31.852.252/0001-72", "43.820.625/0001-02",
    "40.814.547/0001-45", "14.882.110/0001-39", "37.357.836/0001-58",
    "47.876.244/0001-04", "85.176.743/0001-70", "10.614.624/0001-52",
    "33.846.475/0001-52", "22.013.213/0001-90", "70.800.248/0001-12",
    "32.530.306/0001-46", "05.111.461/0001-55", "17.386.176/0001-26",
    "08.411.128/0001-50", "15.204.257/0001-32", "21.140.474/0001-09",
    "86.170.254/0001-73", "82.500.660/0001-04", "22.170.116/0001-01",
    "42.006.213/0001-70", "41.070.736/0001-13", "75.347.665/0001-75",
    "12.635.676/0001-30", "27.771.554/0001-49", "60.286.242/0001-15",
    "23.205.583/0001-92", "36.720.508/0001-01", "08.268.032/0001-84",
    "78.201.025/0001-40", "66.486.060/0001-74", "23.483.722/0001-40",
    "35.083.835/0001-37", "40.424.864/0001-55", "51.622.651/0001-54",
    "72.734.408/0001-06", "55.413.258/0001-01", "52.641.488/0001-30",
    "84.557.555/0001-29", "51.127.216/0001-53", "00.368.078/0001-63",
    "16.456.132/0001-62", "63.720.502/0001-07", "28.443.458/0001-34",
    "31.685.521/0001-53", "05.534.424/0001-50", "54.164.075/0001-37",
    "23.670.653/0001-83", "64.544.558/0001-10", "10.104.314/0001-98",
    "03.001.650/0001-40", "51.004.660/0001-81", "52.470.331/0001-99",
    "20.248.820/0001-04", "33.107.320/0001-02", "32.307.248/0001-96",
    "24.238.723/0001-91", "57.760.665/0001-10", "24.018.325/0001-60",
    "24.267.558/0001-04", "37.137.173/0001-66", "58.428.831/0001-49",
    "70.405.757/0001-40", "16.011.145/0001-28", "05.280.774/0001-37",
    "44.460.611/0001-98", "87.587.687/0001-91", "28.046.264/0001-03",
    "84.666.263/0001-24", "00.543.706/0001-08", "32.523.502/0001-93",
    "32.863.406/0001-94", "77.202.660/0001-80", "85.713.402/0001-96",
    "67.268.161/0001-31", "53.483.724/0001-08", "81.671.210/0001-03",
    "64.458.167/0001-83", "40.620.662/0001-89", "10.654.773/0001-45",
    "34.116.472/0001-26", "15.260.147/0001-98", "36.020.516/0001-45",
    "31.875.782/0001-36", "44.636.074/0001-94", "40.553.400/0001-49",
    "85.676.336/0001-21", "43.704.012/0001-00", "13.757.364/0001-62",
    "22.850.472/0001-76", "21.380.345/0001-98", "83.025.858/0001-38",
    "53.422.118/0001-74", "44.217.754/0001-73", "48.520.862/0001-71",
    "87.210.272/0001-02", "66.655.633/0001-46", "42.746.028/0001-12",
    "45.403.046/0001-90", "82.060.414/0001-70", "85.540.042/0001-78",
    "25.816.132/0001-17", "47.582.051/0001-32", "71.122.733/0001-47",
    "66.546.718/0001-96", "53.438.860/0001-78", "31.516.826/0001-31",
    "03.256.065/0001-90", "20.125.018/0001-27", "45.533.748/0001-98",
    "23.752.850/0001-41", "67.317.212/0001-78", "27.226.557/0001-00",
    "04.227.714/0001-98", "32.245.073/0001-30", "06.261.280/0001-78",
    "80.802.002/0001-33", "85.225.855/0001-73", "25.742.241/0001-37",
    "06.228.321/0001-24", "23.272.263/0001-55", "64.242.047/0001-44",
    "53.050.012/0001-97", "86.483.066/0001-03", "52.101.124/0001-67",
    "08.264.123/0001-41", "84.581.367/0001-36", "88.147.250/0001-08",
    "61.722.275/0001-23", "62.607.633/0001-10", "51.537.288/0001-79",
    "08.354.330/0001-97", "07.441.603/0001-78", "77.525.752/0001-09",
    "58.847.071/0001-04", "85.148.807/0001-29", "76.323.868/0001-94",
    "16.223.177/0001-97", "51.054.684/0001-45", "18.381.662/0001-14",
    "21.557.402/0001-61", "16.440.342/0001-62", "46.730.260/0001-13",
    "85.118.165/0001-15", "38.200.106/0001-01", "25.774.333/0001-07",
    "82.161.117/0001-11", "40.241.044/0001-28", "74.127.586/0001-96",
    "21.738.323/0001-57", "80.702.582/0001-97", "38.323.438/0001-83",
    "54.670.357/0001-06", "68.706.015/0001-03", "53.156.555/0001-93",
    "06.857.546/0001-40", "01.632.382/0001-39", "26.861.110/0001-31",
    "24.805.162/0001-65", "23.258.563/0001-80", "14.610.387/0001-02",
    "81.250.120/0001-49", "67.533.231/0001-31", "18.845.636/0001-08",
    "02.688.000/0001-51", "25.766.382/0001-90", "02.607.503/0001-55",
    "23.128.730/0001-78", "30.803.431/0001-57", "17.317.537/0001-82",
    "28.837.265/0001-68", "21.006.760/0001-86", "17.153.533/0001-06",
    "66.280.501/0001-87", "66.656.520/0001-65", "08.303.772/0001-04",
    "15.821.871/0001-43", "83.635.353/0001-95", "40.288.464/0001-60",
    "43.737.167/0001-42", "02.825.214/0001-22", "71.122.658/0001-14",
    "28.136.205/0001-18", "31.607.753/0001-93", "03.515.626/0001-29",
    "04.575.637/0001-67", "71.024.238/0001-03", "50.062.840/0001-57",
    "56.556.844/0001-78", "75.117.326/0001-00", "31.657.851/0001-35",
    "66.548.186/0001-26", "10.801.605/0001-35", "21.873.612/0001-69",
    "42.030.616/0001-55", "11.082.146/0001-40", "60.802.723/0001-36",
    "55.004.110/0001-13", "21.275.624/0001-91", "22.665.773/0001-20",
    "15.026.457/0001-42", "44.000.140/0001-35", "56.634.103/0001-68",
    "78.070.483/0001-98", "26.671.885/0001-44", "23.642.852/0001-88",
    "07.216.250/0001-02", "53.871.585/0001-81", "62.181.008/0001-59",
    "71.870.360/0001-92", "78.168.278/0001-60", "24.444.337/0001-56",
    "66.038.320/0001-49", "12.156.308/0001-00", "07.085.806/0001-79",
    "00.852.161/0001-03", "22.007.788/0001-09", "12.014.255/0001-92",
    "38.472.163/0001-40", "67.128.257/0001-02", "10.142.258/0001-86",
    "56.346.726/0001-35", "21.735.232/0001-68", "15.348.622/0001-82",
    "53.447.551/0001-64", "25.586.106/0001-40", "66.168.836/0001-08",
    "02.713.052/0001-30", "44.568.252/0001-97", "61.062.233/0001-03",
    "14.015.384/0001-20", "74.588.887/0001-17", "27.865.681/0001-07",
    "75.802.730/0001-05", "26.383.625/0001-73", "48.542.581/0001-10",
    "52.231.643/0001-40", "18.484.074/0001-06", "85.361.854/0001-56",
    "47.077.685/0001-38", "48.827.502/0001-17", "08.566.041/0001-51",
    "38.003.420/0001-02", "07.760.374/0001-54", "05.638.871/0001-59",
    "75.826.358/0001-77", "66.388.550/0001-38", "84.823.826/0001-40",
    "54.470.460/0001-02", "70.175.723/0001-07", "54.672.323/0001-50",
    "13.414.045/0001-54", "20.067.083/0001-43", "58.840.825/0001-02",
    "84.402.112/0001-69", "16.883.644/0001-05", "27.851.528/0001-20",
    "61.271.247/0001-37", "02.016.551/0001-79", "78.072.587/0001-31",
    "01.661.620/0001-34", "40.663.235/0001-88", "81.350.345/0001-77",
    "74.561.547/0001-00", "06.572.848/0001-71", "76.512.440/0001-90",
    "03.715.010/0001-00", "76.243.223/0001-41", "37.317.354/0001-74",
    "73.703.355/0001-10", "61.743.528/0001-45", "68.552.003/0001-71",
    "42.181.004/0001-63", "86.385.551/0001-36", "17.857.617/0001-20",
    "75.834.015/0001-54", "55.723.480/0001-00", "31.040.303/0001-61",
    "24060703000173", "64.701.424/0001-66", "57.353.810/0001-49",
    "41824061000150", "00.217.202/0001-90", "22.454.084/0001-76",
    "51267036000177", "33.344.623/0001-30", "18.518.624/0001-60",
    "00420747000107", "65.311.628/0001-53", "35.402.647/0001-24",
    "28326401000155", "81.172.356/0001-04", "17.255.404/0001-29",
    "81815223000109", "24.586.235/0001-75", "64.050.716/0001-86",
    "23303033000106",
  ]
}
