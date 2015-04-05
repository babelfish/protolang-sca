protolang-sca
=============

Prerequisites:
 * Perl ~> 5.1
 * [rsca](http://000024.org/rsca.html) built in project directory
 * Some Unix shell variant

Usage:
  `./run <input-file>`

Expects to find rsca sound change rules in the file `ruleset`.
Formatted protolang wordlists are provided (sorted alphabetically).
Converts IPA values from word list into CXS (an X-SAMPA variant, see http://www.theiling.de/ipa/ for details) so
rsca can parse it then converts the rsca output back to IPA.
