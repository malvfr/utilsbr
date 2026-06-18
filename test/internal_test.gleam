//// Direct unit tests for internal modules. These close branch-coverage gaps
//// that the public API cannot reach on its own (e.g. the empty-string arm of
//// `all_characteres_are_equal`, every arm of the mod-11 helper, and the
//// length guard inside `validate_alphanumeric`).
////
//// Intentionally NOT covered, because they are unreachable defensive code:
////   * The `True -> generate(...)` regeneration branch in the CPF/CNPJ
////     generators — only triggered if `int.random` yields an all-identical
////     document (e.g. all zeros), which is astronomically improbable and
////     cannot be forced without seeding.
////   * The `Error` arms of `char_to_value` / the `try_fold`s in
////     `cnpj/alphanumeric` — only reachable with an empty grapheme, which a
////     cleaned 14-character string can never contain.

import gleeunit/should
import utilsbr/cnpj/alphanumeric
import utilsbr/utils/format
import utilsbr/utils/validation

// --- utils/validation.calculate_verification_digit_mod11 -------------------

pub fn mod11_remainder_zero_test() {
  validation.calculate_verification_digit_mod11(0) |> should.equal(0)
}

pub fn mod11_remainder_one_test() {
  validation.calculate_verification_digit_mod11(1) |> should.equal(0)
}

pub fn mod11_remainder_two_test() {
  validation.calculate_verification_digit_mod11(2) |> should.equal(9)
}

pub fn mod11_remainder_nine_test() {
  validation.calculate_verification_digit_mod11(9) |> should.equal(2)
}

pub fn mod11_remainder_ten_test() {
  validation.calculate_verification_digit_mod11(10) |> should.equal(1)
}

// --- utils/format.all_characteres_are_equal --------------------------------

pub fn all_equal_empty_string_test() {
  // The empty-string arm is unreachable through validation (length is checked
  // first) but is part of the function's contract.
  format.all_characteres_are_equal("") |> should.be_true
}

pub fn all_equal_single_char_test() {
  format.all_characteres_are_equal("A") |> should.be_true
}

pub fn all_equal_all_same_test() {
  format.all_characteres_are_equal("00000000000000") |> should.be_true
  format.all_characteres_are_equal("aaaa") |> should.be_true
}

pub fn all_equal_differs_at_end_test() {
  format.all_characteres_are_equal("aaab") |> should.be_false
}

pub fn all_equal_differs_at_start_test() {
  format.all_characteres_are_equal("baaa") |> should.be_false
}

// --- cnpj/alphanumeric.validate_alphanumeric length guard ------------------

pub fn validate_alphanumeric_exactly_14_test() {
  alphanumeric.validate_alphanumeric("12ABC34501DE35") |> should.be_true
}

pub fn validate_alphanumeric_too_short_guard_test() {
  alphanumeric.validate_alphanumeric("12ABC34501DE3") |> should.be_false
}

pub fn validate_alphanumeric_too_long_guard_test() {
  alphanumeric.validate_alphanumeric("12ABC34501DE355") |> should.be_false
}
