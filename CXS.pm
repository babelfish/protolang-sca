# # Copyright (c) Henrik Theiling
# ===================================================================
# Licence Version 2
# -----------------
#
# This software is provided 'as-is', without warranty of any kind,
# express or implied.  In no event will the authors or copyright holders
# be held liable for any damages arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must
#    not claim that you wrote the original software. If you use this
#    software in a product, an acknowledgment in the product documentation
#    would be appreciated.
#
# 2. Altered source versions must be plainly marked as such, and must
#    not be misrepresented as being the original software.
#
# 3. You must not use any of the names of the authors or copyright
#    holders of the original software for advertising or publicity
#    pertaining to distribution without specific, written prior
#    permission.
#
# 4. If you change this software and redistribute parts or all of it in
#    any form, you must make the source code of the altered version of this
#    software available.
#
# 5. This notice must not be removed or altered from any source
#    distribution.
#
# This licence is governed by the Laws of Germany.  Disputes shall be
# settled by Saarbruecken City Court.
#
# Generated automatically, do not edit.
#
# Recent versions of this module will be uploaded to:
# http://www.theiling.de/ipa/
# -*- Mode: Perl -*-
#
# Module history:
#   V1.15: HTML glitch found by Arthaey
#   V1.07: Added code for CXS_HTML
#   V1.06: Added cxs_encode_html() because HTML::Entities::encode_entities
#          fails for old(?) Perl versions.
#   V1.05: Added a lot of configurability
#          Added support for automatic _0 and _= placement in IPA.
#   V1.04: Handled ) in CXS->IPA conversion.
#          Error detection.
#   V1.03: Fixed bug in ipa2cxs.
#          Made compatible with Perl 5.004 (no 'U' conversion in pack/unpack).
#   V1.02: Added a supplement list for CXS->IPA translation.
#   V1.01: Changed a loop in cxs2ipa to restart for each match.
#          Added combining class information.
#   V1.00: Initial version: thanks to Mark J. Reed who provided the
#          module wrap around the tabular data.

# Some problems:
#   - some conversions are too static, e.g. 'ring above' for voiceless, where
#     'ring below' is a better alternative for some modified characters.

package CXS;

use strict;
use warnings;
use base 'Exporter';
use vars qw($VERSION @EXPORT);

$VERSION= 1.07;

@EXPORT = qw(
    ipa2cxs
    cxs2ipa
    pack_U
    unpack_U
    cxs_init
    cxs_set_ipa2cxs
    cxs_set_ipa_deprecated
    cxs_get_ipa_deprecated
    cxs_set_ipa_combining
    cxs_get_ipa_combining
    cxs_unset_ipa2cxs
    cxs_set_cxs2ipa
    cxs_unset_cxs2ipa
    cxs_get_cxs2ipa_supplement
    cxs_set_special
    cxs_get_special
    cxs_version
    cxs_encode_html
    cxs_get_ipa2cxs
);

my %charmap_cxs= (
  0x00E6 => { cxs=>"&", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x00E7 => { cxs=>"C", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x00F0 => { cxs=>"D", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x00F8 => { cxs=>"2", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0020 => { cxs=>" ", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x002E => { cxs=>".", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x007C => { cxs=>"|", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0061 => { cxs=>"a", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0062 => { cxs=>"b", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0063 => { cxs=>"c", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0064 => { cxs=>"d", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0065 => { cxs=>"e", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0066 => { cxs=>"f", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0068 => { cxs=>"h", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0069 => { cxs=>"i", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x006A => { cxs=>"j", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x006B => { cxs=>"k", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x006C => { cxs=>"l", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x006D => { cxs=>"m", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x006E => { cxs=>"n", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x006F => { cxs=>"o", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0070 => { cxs=>"p", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0071 => { cxs=>"q", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0072 => { cxs=>"r", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0073 => { cxs=>"s", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0074 => { cxs=>"t", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0075 => { cxs=>"u", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0076 => { cxs=>"v", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0077 => { cxs=>"w", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0078 => { cxs=>"x", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0079 => { cxs=>"y", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x007A => { cxs=>"z", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0127 => { cxs=>"X\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x014B => { cxs=>"N", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0153 => { cxs=>"9", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0180 => { cxs=>"B", combining=>0, deprecated=>1, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x01A5 => { cxs=>"p_<", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x01AB => { cxs=>"t_j", combining=>0, deprecated=>1, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x01AD => { cxs=>"t_<", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x01BB => { cxs=>"dz)", combining=>0, deprecated=>1, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x01C0 => { cxs=>"|\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x01C1 => { cxs=>"|\\|\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x01C2 => { cxs=>"=\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x01C3 => { cxs=>"!\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0250 => { cxs=>"6", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0251 => { cxs=>"A", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0252 => { cxs=>"Q", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0253 => { cxs=>"b_<", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0254 => { cxs=>"O", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0255 => { cxs=>"s\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0256 => { cxs=>"d`", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>-1, modif=>0, skip=>0 }, 
  0x0257 => { cxs=>"d_<", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0258 => { cxs=>"@\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0259 => { cxs=>"@", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x025A => { cxs=>"@`", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x025B => { cxs=>"E", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x025C => { cxs=>"3", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x025D => { cxs=>"3`", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x025E => { cxs=>"3\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x025F => { cxs=>"J\\", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0260 => { cxs=>"g_<", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>1, modif=>0, skip=>0 }, 
  0x0261 => { cxs=>"g", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0262 => { cxs=>"G\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0263 => { cxs=>"G", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0264 => { cxs=>"7", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0265 => { cxs=>"H", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0266 => { cxs=>"h\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0267 => { cxs=>"x\\", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>-1, modif=>0, skip=>0 }, 
  0x0268 => { cxs=>"1", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0269 => { cxs=>"I", combining=>0, deprecated=>1, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x026A => { cxs=>"I", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x026B => { cxs=>"5", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x026C => { cxs=>"K", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x026D => { cxs=>"l`", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x026E => { cxs=>"K\\", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x026F => { cxs=>"M", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0270 => { cxs=>"M\\", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0271 => { cxs=>"F", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0272 => { cxs=>"J", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0273 => { cxs=>"n`", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0274 => { cxs=>"N\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0275 => { cxs=>"8", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0276 => { cxs=>"&\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0277 => { cxs=>"U", combining=>0, deprecated=>1, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0278 => { cxs=>"p\\", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0279 => { cxs=>"r\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x027A => { cxs=>"l\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x027B => { cxs=>"r\\`", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x027C => { cxs=>"r\\_r", combining=>0, deprecated=>1, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x027D => { cxs=>"r`", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x027E => { cxs=>"4", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x027F => { cxs=>"z=", combining=>0, deprecated=>1, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0280 => { cxs=>"R\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0281 => { cxs=>"R", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0282 => { cxs=>"s`", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0283 => { cxs=>"S", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0284 => { cxs=>"J\\_<", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0285 => { cxs=>"z`=", combining=>0, deprecated=>1, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0286 => { cxs=>"S_j", combining=>0, deprecated=>1, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0287 => { cxs=>"|\\", combining=>0, deprecated=>1, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0288 => { cxs=>"t`", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>1, modif=>0, skip=>0 }, 
  0x0289 => { cxs=>"u\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x028A => { cxs=>"U", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x028B => { cxs=>"v\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x028C => { cxs=>"V", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x028D => { cxs=>"W", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x028E => { cxs=>"L", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x028F => { cxs=>"Y", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0290 => { cxs=>"z`", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0291 => { cxs=>"z\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0292 => { cxs=>"Z", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0293 => { cxs=>"Z_j", combining=>0, deprecated=>1, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0294 => { cxs=>"?", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0295 => { cxs=>"?\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0296 => { cxs=>"|\\|\\", combining=>0, deprecated=>1, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0297 => { cxs=>"!\\", combining=>0, deprecated=>1, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x0298 => { cxs=>"O\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0299 => { cxs=>"B\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x029A => { cxs=>"&\\", combining=>0, deprecated=>1, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x029B => { cxs=>"G\\_<", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x029C => { cxs=>"H\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x029D => { cxs=>"j\\", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x029F => { cxs=>"L\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02A0 => { cxs=>"q_<", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>1, modif=>0, skip=>0 }, 
  0x02A1 => { cxs=>">\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02A2 => { cxs=>"<\\", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02A3 => { cxs=>"dz)", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02A4 => { cxs=>"dZ)", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x02A5 => { cxs=>"dz\\)", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02A6 => { cxs=>"ts)", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02A7 => { cxs=>"tS)", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x02A8 => { cxs=>"ts\\)", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02A9 => { cxs=>"fN)", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x02AA => { cxs=>"ls)", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02AB => { cxs=>"lz)", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02AC => { cxs=>"._w_w", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02AD => { cxs=>"._d_d", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02B0 => { cxs=>"_h", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02B1 => { cxs=>"_t", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02B2 => { cxs=>"_j", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02B7 => { cxs=>"_w", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02B8 => { cxs=>"_j", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02BC => { cxs=>"_>", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02C0 => { cxs=>"_>", combining=>0, deprecated=>1, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02C7 => { cxs=>"_F_R", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02C8 => { cxs=>"'", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02C9 => { cxs=>"_T", combining=>0, deprecated=>1, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02CC => { cxs=>"\"", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02CD => { cxs=>"_L", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02CE => { cxs=>"_L_B", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02CF => { cxs=>"_B_L", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02D0 => { cxs=>":", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02D1 => { cxs=>":\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02D2 => { cxs=>"_O", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02D3 => { cxs=>"_c", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02D4 => { cxs=>"_r", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02D5 => { cxs=>"_o", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02D6 => { cxs=>"_+", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02D7 => { cxs=>"_-", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02D8 => { cxs=>"_X", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02DA => { cxs=>"_0", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02DC => { cxs=>"~", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02DD => { cxs=>"_T", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02DE => { cxs=>"`", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02E0 => { cxs=>"_G", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02E1 => { cxs=>"_l", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02E4 => { cxs=>"_?\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x02E5 => { cxs=>"_T", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x02E6 => { cxs=>"_H", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02E7 => { cxs=>"_M", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02E8 => { cxs=>"_L", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02E9 => { cxs=>"_B", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>0 }, 
  0x02EC => { cxs=>"_v", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>1, skip=>1 }, 
  0x0300 => { cxs=>"_L", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0301 => { cxs=>"_H", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0302 => { cxs=>"_F", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0303 => { cxs=>"~", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0304 => { cxs=>"_M", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0306 => { cxs=>"_X", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0308 => { cxs=>"_\"", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x030A => { cxs=>"_0", combining=>230, deprecated=>1, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x030B => { cxs=>"_T", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x030C => { cxs=>"_R", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x030D => { cxs=>"=", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x030F => { cxs=>"_B", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0318 => { cxs=>"_A", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0319 => { cxs=>"_q", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x031A => { cxs=>"_}", combining=>232, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x031C => { cxs=>"_c", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x031D => { cxs=>"_r", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x031E => { cxs=>"_o", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x031F => { cxs=>"_+", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0320 => { cxs=>"_-", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0321 => { cxs=>"_j", combining=>202, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0322 => { cxs=>"`", combining=>202, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0324 => { cxs=>"_t", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0325 => { cxs=>"_0", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0328 => { cxs=>"~", combining=>202, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0329 => { cxs=>"=", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x032A => { cxs=>"_d", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x032B => { cxs=>"_w", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x032C => { cxs=>"_v", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x032F => { cxs=>"_^", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0330 => { cxs=>"_k", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0334 => { cxs=>"_e", combining=>1, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0339 => { cxs=>"_O", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x033A => { cxs=>"_a", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x033B => { cxs=>"_m", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x033C => { cxs=>"_N", combining=>220, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x033D => { cxs=>"_x", combining=>230, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x0361 => { cxs=>"_", combining=>234, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x03B2 => { cxs=>"B", combining=>0, deprecated=>0, ascend=>1, descend=>1, accent=>-1, modif=>0, skip=>0 }, 
  0x03B8 => { cxs=>"T", combining=>0, deprecated=>0, ascend=>1, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x03C7 => { cxs=>"X", combining=>0, deprecated=>0, ascend=>0, descend=>1, accent=>0, modif=>0, skip=>0 }, 
  0x2016 => { cxs=>"||", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x203F => { cxs=>"-\\", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x207F => { cxs=>"_n", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x2191 => { cxs=>"^", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x2193 => { cxs=>"!", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x2197 => { cxs=>"<R>", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
  0x2198 => { cxs=>"<F>", combining=>0, deprecated=>0, ascend=>0, descend=>0, accent=>0, modif=>0, skip=>0 }, 
);

my %charmap_ipa_supplement= (
    "v\\" => [ 0x028B ],
    "P" => [ 0x028B ],
    "1" => [ 0x0268 ],
    "i\\" => [ 0x0268 ],
    "I\\" => [ 0x026A, 0x0335 ],
    "U\\" => [ 0x028A, 0x0336 ],
    "l_e" => [ 0x026B ],
    ";" => [ 0x02B2 ],
    "%" => [ 0x02CC ],
    "," => [ 0x02CC ],
    "_~" => [ 0x0303 ],
    "_=" => [ 0x0329 ],
    "=" => [ 0x0329 ],
    "~" => [ 0x0303 ],
    "_0" => [ 0x0325 ],
    "d_z" => [ 0x0064, 0x0361, 0x007A ],
    "d_Z" => [ 0x0064, 0x0361, 0x0292 ],
    "d_z\\" => [ 0x0064, 0x0361, 0x0291 ],
    "t_s" => [ 0x0074, 0x0361, 0x0073 ],
    "t_S" => [ 0x0074, 0x0361, 0x0283 ],
    "t_s\\" => [ 0x0074, 0x0361, 0x0255 ],
    "f_N" => [ 0x0066, 0x0361, 0x014B ],
    "l_s" => [ 0x006C, 0x0361, 0x0073 ],
    "l_z" => [ 0x006C, 0x0361, 0x007A ],
    "_j" => [ 0x02B2 ],
    "_w" => [ 0x02B7 ],
    "_T" => [ 0x02E5 ],
    "_H" => [ 0x02E6 ],
    "_M" => [ 0x02E7 ],
    "_L" => [ 0x02E8 ],
    "_B" => [ 0x02E9 ],
    "kp)" => [ 0x006B, 0x0361, 0x0070 ],
    "gb)" => [ 0x0067, 0x0361, 0x0062 ],
    "Nm)" => [ 0x014B, 0x0361, 0x006D ],
    "dz)" => [ 0x0064, 0x0361, 0x007A ],
    "dZ)" => [ 0x0064, 0x0361, 0x0292 ],
    "dz\\)" => [ 0x0064, 0x0361, 0x0291 ],
    "ts)" => [ 0x0074, 0x0361, 0x0073 ],
    "tS)" => [ 0x0074, 0x0361, 0x0283 ],
    "ts\\)" => [ 0x0074, 0x0361, 0x0255 ],
    "fN)" => [ 0x0066, 0x0361, 0x014B ],
    "ls)" => [ 0x006C, 0x0361, 0x0073 ],
    "lz)" => [ 0x006C, 0x0361, 0x007A ],
    "aI)" => [ 0x0061, 0x0361, 0x026A ],
    "aU)" => [ 0x0061, 0x0361, 0x028A ],
    "OI)" => [ 0x0254, 0x0361, 0x026A ],
    "OY)" => [ 0x0254, 0x0361, 0x028F ],
    "c\\" => [ 0x0255 ],
);

sub cxs_get_ipa2cxs()
{
    return \%charmap_cxs;
}

# For old Perl versions that don't have 'U' conversion (like my Web provider, grrrr):

sub pack_U_special {
   my $result= "";
   for (@_) {
        #if ($_ > 0x3ffffff) {
        #    $result.= chr(0xfc + (($_ >> 30) & 0x01)).
        #              chr(0x80 + (($_ >> 24) & 0x3f)).
        #              chr(0x80 + (($_ >> 18) & 0x3f)).
        #              chr(0x80 + (($_ >> 12) & 0x3f)).
        #              chr(0x80 + (($_ >> 6)  & 0x3f)).
        #              chr(0x80 + (($_ >> 0)  & 0x3f));
        #}
        #else
        #if ($_ > 0x1fffff) {
        #    $result.= chr(0xf8 + (($_ >> 24) & 0x03)).
        #              chr(0x80 + (($_ >> 18) & 0x3f)).
        #              chr(0x80 + (($_ >> 12) & 0x3f)).
        #              chr(0x80 + (($_ >> 6)  & 0x3f)).
        #              chr(0x80 + (($_ >> 0)  & 0x3f));
        #}
        #else
        if ($_ > 0xffff) {
            $result.= chr(0xf0 + (($_ >> 18) & 0x07)).
                      chr(0x80 + (($_ >> 12) & 0x3f)).
                      chr(0x80 + (($_ >> 6)  & 0x3f)).
                      chr(0x80 + (($_ >> 0)  & 0x3f));
        }
        elsif ($_ > 0x7ff) {
            $result.= chr(0xe0 + (($_ >> 12) & 0x0f)).
                      chr(0x80 + (($_ >> 6)  & 0x3f)).
                      chr(0x80 + (($_ >> 0)  & 0x3f));
        }
        elsif ($_ > 0x7f) {
            $result.= chr(0xc0 + (($_ >> 6)  & 0x1f)).
                      chr(0x80 + (($_ >> 0)  & 0x3f));
        }
        else {
            $result.= chr($_);
        }
    }
    return $result;
}

sub pack_U_native
{
    return pack("U",@_);
}

my $utf_char_re=
        '[\x00-\x7f]|'.
        '[\xc0-\xdf][\x80-\xbf]|'.
        '[\xe0-\xef][\x80-\xbf][\x80-\xbf]|'.
        '[\xf0-\xf7][\x80-\xbf][\x80-\xbf][\x80-\xbf]';

sub unpack_U_special($) {
    $_= shift;
    my $len= length($_);
    my @result= ();
    $_= pack("C*",unpack("C*", $_)); # newer Perls handle UTF-8 'more' correctly...
    pos($_)= 0;
    while (pos($_) < $len) {
        my $pos= pos($_);
        if (pos($_)=$pos, /\G([\x00-\x7f])/g) {
            push @result, ord($1)
        }
        elsif (pos($_)=$pos, /\G([\xc0-\xdf])([\x80-\xbf])/g) {
            push @result, ((ord($1) & 0x1f) << 6) +
                          (ord($2) & 0x3f);
        }
        elsif (pos($_)=$pos, /\G([\xe0-\xef])([\x80-\xbf])([\x80-\xbf])/g) {
            push @result, ((ord($1) & 0x0f) << 12) +
                          ((ord($2) & 0x3f) << 6) +
                          (ord($3) & 0x3f);
        }
        elsif (pos($_)=$pos, /\G([\xf0-\xf7])([\x80-\xbf])([\x80-\xbf])([\x80-\xbf])/g) {
            push @result, ((ord($1) & 0x07) << 18) +
                          ((ord($2) & 0x3f) << 12) +
                          ((ord($3) & 0x3f) << 6) +
                          (ord($4) & 0x3f);
        }
        #elsif (pos($_)=$pos,
        #       /\G([\xf8-\xfb])([\xf8-\xfb])([\x80-\xbf])([\x80-\xbf])([\x80-\xbf])/g)
        #{
        #    push @result, ((ord($1) & 0x03) << 24) +
        #                  ((ord($2) & 0x3f) << 18) +
        #                  ((ord($3) & 0x3f) << 12) +
        #                  ((ord($4) & 0x3f) << 6) +
        #                  (ord($5) & 0x3f);
        #}
        #elsif (pos($_)=$pos,
        #       /\G([\xfc-\xfd])([\xf8-\xfb])([\x80-\xbf])([\x80-\xbf])([\x80-\xbf])([\x80-\xbf])/g)
        #{
        #    push @result, ((ord($1) & 0x01) << 30) +
        #                  ((ord($2) & 0x3f) << 24) +
        #                  ((ord($3) & 0x3f) << 18) +
        #                  ((ord($4) & 0x3f) << 12) +
        #                  ((ord($5) & 0x3f) << 6) +
        #                  (ord($6) & 0x3f);
        #}
        else {
            die "Illegal UTF-8 sequence at '".substr($_,$pos)."' = ".
                join(" ",map { sprintf("%02X",$_) } unpack("C*",substr($_,$pos)));
        }
    }
    return @result;
}

sub unpack_U_native
{
    return unpack("U*",@_);
}

my $cxs_pack_u=   \&pack_U_native;
my $cxs_unpack_u= \&unpack_U_native;
#eval 'pack("U",368);';  # FIXME: check whether "U" works.
#if ($@) {
#   die "Shoot!";
   $cxs_pack_u=   \&pack_U_special;
   $cxs_unpack_u= \&unpack_U_special;
#}

sub pack_U {
    return &$cxs_pack_u(@_);
}

sub unpack_U {
    return &$cxs_unpack_u(@_);
}

# reverse %charmap_cxs, pay attention to combining class and deprecation level
my %charmap_ipa=   ();
my @cxs_sequences= ();
my %cxs_special=   (
    ')'  => 1,  # conversion of t_s -> ts)
    '_0' => 1,  # automatic placement of voiceless above or below
    '='  => 0   # (non-IPA?): automatic placement of syllabic above or below
);

sub cxs_init()
{
    my ($k,$v);
    %charmap_ipa= ();

    while (($k,$v)= each %charmap_cxs) {
        if (!$v->{deprecated} &&
            ($v->{combining} || !defined $charmap_ipa{$v->{cxs}}))
        {
            $charmap_ipa{$v->{cxs}}= [ $k ];
        }
    }

    # incorporate special supplements:
    while (($k,$v)= each %charmap_ipa_supplement) {
        $charmap_ipa{$k}= $v;
    }

    @cxs_sequences = sort { length($b) <=> length($a) } keys %charmap_ipa;
}

cxs_init(); ## initialisation.  May be invoked again if the tables are changed.

# modify the tables:
sub cxs_unset_ipa2cxs($)
{
    my ($ipa)= @_;
    delete $charmap_cxs{$ipa};
}

sub cxs_set_ipa2cxs($$$;$)
{
    my ($ipa, $cxs, $combining, $deprecated)= @_;
    return cxs_unset_ipa2cxs($cxs)
        unless defined $cxs;

    $charmap_cxs{$ipa}= {
        cxs => $cxs,
        combining => $combining,
        deprecated => $deprecated
    };
}

sub cxs_set_ipa_deprecated($$)
{
    my ($ipa, $value)= @_;
    $charmap_cxs{$ipa}->{deprecated}= $value if $charmap_cxs{$ipa};
}

sub cxs_get_ipa_deprecated($)
{
    my ($ipa)= @_;
    return $charmap_cxs{$ipa} && $charmap_cxs{$ipa}->{deprecated};
}

sub cxs_set_ipa_combining($$)
{
    my ($ipa, $value)= @_;
    $charmap_cxs{$ipa}->{combining}= $value if $charmap_cxs{$ipa};
}

sub cxs_get_ipa_combining($)
{
    my ($ipa)= @_;
    return $charmap_cxs{$ipa} && $charmap_cxs{$ipa}->{combining};
}

sub cxs_unset_cxs2ipa($)
{
    my ($cxs)= @_;
    delete $charmap_ipa_supplement{$cxs};
}

sub cxs_get_cxs2ipa_supplement($)
{
    my ($cxs)= @_;
    return $charmap_ipa_supplement{$cxs};
}

sub cxs_set_cxs2ipa($$)
{
    my ($cxs, $ipa)= @_;
    return cxs_unset_cxs2ipa($cxs)
        unless defined $ipa;

    $ipa= [ $ipa ] unless ref($ipa) eq "ARRAY";
    $charmap_ipa_supplement{$cxs}= $ipa;
}

sub cxs_set_special($$)
{
    my ($special, $value)= @_;
    $cxs_special{$special}= $value;
}

sub cxs_get_special($)
{
    my ($special)= @_;
    return $cxs_special{$special};
}

{
    my %html_encoding=();

    $html_encoding{13}= '';
    $html_encoding{34}= '&#34;';
    $html_encoding{38}= '&#38;';
    $html_encoding{60}= '&#60;';
    $html_encoding{62}= '&#62;';

    sub cxs_encode_html($)
    {
        return join ('', map {
                   my $h= $html_encoding{$_};
                   defined $h ? $h : $_ < 128 ? chr($_) : sprintf("&#%d;", $_)
               } unpack_U($_[0]));
    }
}

sub identity($) { return $_[0]; }

sub quote_html($)
{
    my ($s)= @_;
    $s=~ s/([<>&\"\x80-\xff])/'&#'.unpack("C",$1).';'/ge;
    return $s;
}

sub sup_quote($)
{
    my ($s)= @_;
    if ($s=~ s/^_//) {
        return length($s) ?
                  { text => '<sup>'.quote_html($s).'</sup>', comb => 1 }
               :  { text => '_', comb => 2 };
    }
    return { text => quote_html($s) };
}

sub ipa2cxs ($;$$$)
{
    my ($ipa, $quote, $err_prefix, $err_suffix)= @_;
    $quote||= \&identity;
    $err_prefix||= "";
    $err_suffix||= "";

    my ($prefix, $suffix)= ("", "");
    ($prefix, $ipa, $suffix)= ('[', $1, ']') if $ipa =~ m@^\s*\[(.*)\]\s*$@;
    ($prefix, $ipa, $suffix)= ('/', $1, '/') if $ipa =~ m@^\s*/(.*)/\s*$@;

    my $ipa_out=   "";
    my $supipa=    '';
    my @supipa=    ();
    my $err_count= 0;
    my $cxs = '';

    my $pending= 0;        # 1 insert after next letter, 2 means insert before next letter
    my $pending_text= "";
    for my $char (unpack_U($ipa)) {
        if ($char == 0x0361 && $cxs_special{')'}) {
            $pending= 1;
            $pending_text= &$quote(')');
            $ipa_out.= &$quote(pack_U($char));
            push @supipa, { text => '_', comb => 2 };
        }
        else {
            my $repl= $charmap_cxs{$char};
            my $comb= 0;
            my $text= "";
            if ($repl) {
                $text= &$quote($repl->{cxs});
                $comb= $repl->{combining} || $repl->{skip};
                $ipa_out.= &$quote(pack_U($char));
                push @supipa, sup_quote($repl->{cxs});
            }
            else {
                   # not found: copy and mark
                $text=         $err_prefix.&$quote(pack_U($char)).$err_suffix;
                $ipa_out.=     $err_prefix.&$quote(pack_U($char)).$err_suffix;
                push @supipa, { text => '<span class="error">'.quote_html(pack_U($char)).'</span>' };
                $err_count++;
            }
            if ($pending && !$comb) { # found letter
                if ($pending == 1) {
                    $pending= 2;
                }
                else {
                    $cxs.= $pending_text;
                    $pending= 0;
                }
            }
            $cxs.= $text;
        }
    }
    if ($pending) {
        $cxs.= $pending_text;
    }
    $cxs= $prefix.$cxs.$suffix;

    if (wantarray) {
        $ipa_out= $prefix.$ipa_out.$suffix;

        my $o= 0;
        for (my $i=0; $i <= $#supipa; $i++) {
            $o= $i unless $supipa[$i]{comb};
            if ($supipa[$i]{text} eq '_') {
                splice @supipa, $i, 1;
                splice @supipa, $o, 0, { text => '<u>', comb => 3 };
                my $p= $i+1;
                while ($p <= $#supipa &&  $supipa[$p]{comb}) { $p++; }
                if    ($p <= $#supipa && !$supipa[$p]{comb}) { $p++; }
                while ($p <= $#supipa &&  $supipa[$p]{comb}) { $p++; }
                splice @supipa, $p, 0, { text => '</u>', comb => 3 };
            }
        }

        $supipa=  $prefix.join('', map { $_->{text} } @supipa).$suffix;
    }

    return wantarray ? ($cxs, $ipa_out, $err_count, $supipa) : $cxs;
}

sub cxs2ipa ($;$$$)
# This accepts a string packed with pack_U (although usually, the input
# should be plain ASCII).
#
# It outputs a string that is also packed with pack_U.
{
    my ($cxs, $quote, $err_prefix, $err_suffix)= @_;
    $quote||= \&identity;
    $err_prefix||= "";
    $err_suffix||= "";

    my ($prefix, $suffix)= ("", "");
    ($prefix, $cxs, $suffix)= ('[', $1, ']') if $cxs =~ m@^\s*\[(.*)\]\s*$@;
    ($prefix, $cxs, $suffix)= ('/', $1, '/') if $cxs =~ m@^\s*/(.*)/\s*$@;

    my $cxs_out=   '';
    my $err_count= 0;

    my $descend= undef; # trace of last appended letter
    my $ascend=  undef;
    my $accent=  0;

    my @ipa = ();
    pos($cxs)= 0;
    my $len= length($cxs);
    while (pos($cxs) < $len) {
        my $pos= pos($cxs);
        # voiceless:
        my $cxs_append= '';
        if ($cxs_special{'_0'} &&
            (pos($cxs)= $pos, $cxs =~ /\G_0/g))
        {
            $cxs_append= &$quote($charmap_cxs{0x325}->{cxs});
            if (($ascend && $descend) || (!$ascend && !$descend)) { # equally good/bad
                goto above if $accent && $accent > 0;  # any preference?
                goto below if $accent && $accent < 0;
                goto normal; # fall back to user preference
            }
            elsif (!$ascend) { # free on top
            above:
                push @ipa, {
                    text => &$quote(pack_U(0x30a)),
                    comb => 1
                };
                $ascend= 1;
            }
            elsif (!$descend) { # free on bottom
            below:
                push @ipa, {
                    text => &$quote(pack_U(0x325)),
                    comb => 1
                };
                $descend= 1;
            }
            else {
                goto normal; # fall back to user preference
            }
        }
        # syllabic:
        elsif ($cxs_special{'='} &&
            (pos($cxs)= $pos, $cxs =~ /\G_?=/g))
        {
            $cxs_append= &$quote($charmap_cxs{0x329}->{cxs});
            if (($ascend && $descend) || (!$ascend && !$descend)) { # equally good/bad
                goto above2 if $accent && $accent > 0;  # any preference?
                goto below2 if $accent && $accent < 0;
                goto normal; # fall back to user preference
            }
            elsif (!$ascend) { # free on top
            above2:
                push @ipa, {
                    text => &$quote(pack_U(0x30d)),
                    comb => 1
                };
                $ascend= 1;
            }
            elsif (!$descend) { # free on bottom
            below2:
                push @ipa, {
                    text => &$quote(pack_U(0x329)),
                    comb => 1
                };
                $descend= 1;
            }
            else {
                goto normal;
            }
        }
        # linking:
        elsif (pos($cxs)= $pos, $cxs =~ /\G\)/g) {
            my $link= {
                text => &$quote(pack_U(0x0361)),          # linking bar
                comb => $charmap_cxs{0x361}->{combining}  # combining class of the linking bar
            };
            push @ipa, $link;
            $cxs_append= &$quote(')');

            # Backward skip combining diacritics and the last non-combining thingy:
            SWAP: for (my $i=1; $i+1 <= $#ipa; $i++) {
                $ipa[-$i]=   $ipa[-$i-1];
                $ipa[-$i-1]= $link;
                last SWAP unless $ipa[-$i]{comb};
            }
        }
        #normal:
        else {
        normal:
            for my $seq (@cxs_sequences) {
                if (pos($cxs)= $pos, $cxs =~ /\G\Q$seq\E/g) {
                    for my $ipa (@{ $charmap_ipa{$seq} }) {
                        my $entry= $charmap_cxs{$ipa};
                        my $spec= {
                            text  => &$quote(pack_U($ipa)),
                            comb  => $entry->{combining} || $entry->{skip}
                        };
                        push @ipa, $spec;
                        unless ($entry->{combining} || $entry->{modif}) {
                            $ascend=  $entry->{ascend};
                            $descend= $entry->{descend};
                            $accent=  $entry->{accent};
                        }
                        else {
                            $ascend|=  $entry->{ascend};
                            $descend|= $entry->{descend};
                        }
                    }
                    $cxs_append= &$quote($seq);
                    goto next_CHAR;
                }
            }
            # not found: copy and mark:
            pos($cxs)= $pos;
            my $seq= '?';
            $seq= $1 if $cxs =~ /\G($utf_char_re)/g;
            push @ipa, {
                text => $err_prefix.&$quote($seq).$err_suffix,
                comb => 0
            };
            $ascend= $descend= $accent= 0;
            $cxs_append= $err_prefix.&$quote($seq).$err_suffix;
            $err_count++;
        }
    next_CHAR:
        $cxs_out.= $cxs_append;
    }

    $cxs_out= $prefix.$cxs_out.$suffix;
    my $ipa=   $prefix.join('', map { $_->{text} } @ipa).$suffix;

    return wantarray ? ($ipa, $cxs_out, $err_count) : $ipa;
}

1;
