import 'package:intl/intl.dart';

class CurrencyUtils {
  // All ISO 4217 world currencies: code → {locale, symbol, decimal, name}
  static final Map<String, Map<String, dynamic>> _currencyConfigs = {
    'AED': {
      'locale': 'ar_AE',
      'symbol': 'د.إ ',
      'decimal': 2,
      'name': 'UAE Dirham',
    },
    'AFN': {
      'locale': 'fa_AF',
      'symbol': '؋ ',
      'decimal': 2,
      'name': 'Afghan Afghani',
    },
    'ALL': {
      'locale': 'sq_AL',
      'symbol': 'L ',
      'decimal': 2,
      'name': 'Albanian Lek',
    },
    'AMD': {
      'locale': 'hy_AM',
      'symbol': '֏ ',
      'decimal': 2,
      'name': 'Armenian Dram',
    },
    'ANG': {
      'locale': 'nl_AN',
      'symbol': 'ƒ ',
      'decimal': 2,
      'name': 'Netherlands Antillean Guilder',
    },
    'AOA': {
      'locale': 'pt_AO',
      'symbol': 'Kz ',
      'decimal': 2,
      'name': 'Angolan Kwanza',
    },
    'ARS': {
      'locale': 'es_AR',
      'symbol': '\$ ',
      'decimal': 2,
      'name': 'Argentine Peso',
    },
    'AUD': {
      'locale': 'en_AU',
      'symbol': 'A\$ ',
      'decimal': 2,
      'name': 'Australian Dollar',
    },
    'AWG': {
      'locale': 'nl_AW',
      'symbol': 'ƒ ',
      'decimal': 2,
      'name': 'Aruban Florin',
    },
    'AZN': {
      'locale': 'az_AZ',
      'symbol': '₼ ',
      'decimal': 2,
      'name': 'Azerbaijani Manat',
    },
    'BAM': {
      'locale': 'bs_BA',
      'symbol': 'KM ',
      'decimal': 2,
      'name': 'Bosnia-Herzegovina Convertible Mark',
    },
    'BBD': {
      'locale': 'en_BB',
      'symbol': 'Bds\$ ',
      'decimal': 2,
      'name': 'Barbadian Dollar',
    },
    'BDT': {
      'locale': 'bn_BD',
      'symbol': '৳ ',
      'decimal': 2,
      'name': 'Bangladeshi Taka',
    },
    'BGN': {
      'locale': 'bg_BG',
      'symbol': 'лв ',
      'decimal': 2,
      'name': 'Bulgarian Lev',
    },
    'BHD': {
      'locale': 'ar_BH',
      'symbol': 'BD ',
      'decimal': 3,
      'name': 'Bahraini Dinar',
    },
    'BIF': {
      'locale': 'fr_BI',
      'symbol': 'Fr ',
      'decimal': 0,
      'name': 'Burundian Franc',
    },
    'BMD': {
      'locale': 'en_BM',
      'symbol': 'BD\$ ',
      'decimal': 2,
      'name': 'Bermudian Dollar',
    },
    'BND': {
      'locale': 'ms_BN',
      'symbol': 'B\$ ',
      'decimal': 2,
      'name': 'Brunei Dollar',
    },
    'BOB': {
      'locale': 'es_BO',
      'symbol': 'Bs. ',
      'decimal': 2,
      'name': 'Bolivian Boliviano',
    },
    'BRL': {
      'locale': 'pt_BR',
      'symbol': 'R\$ ',
      'decimal': 2,
      'name': 'Brazilian Real',
    },
    'BSD': {
      'locale': 'en_BS',
      'symbol': 'B\$ ',
      'decimal': 2,
      'name': 'Bahamian Dollar',
    },
    'BTN': {
      'locale': 'dz_BT',
      'symbol': 'Nu ',
      'decimal': 2,
      'name': 'Bhutanese Ngultrum',
    },
    'BWP': {
      'locale': 'en_BW',
      'symbol': 'P ',
      'decimal': 2,
      'name': 'Botswanan Pula',
    },
    'BYN': {
      'locale': 'be_BY',
      'symbol': 'Br ',
      'decimal': 2,
      'name': 'Belarusian Ruble',
    },
    'BZD': {
      'locale': 'en_BZ',
      'symbol': 'BZ\$ ',
      'decimal': 2,
      'name': 'Belize Dollar',
    },
    'CAD': {
      'locale': 'en_CA',
      'symbol': 'C\$ ',
      'decimal': 2,
      'name': 'Canadian Dollar',
    },
    'CDF': {
      'locale': 'fr_CD',
      'symbol': 'Fr ',
      'decimal': 2,
      'name': 'Congolese Franc',
    },
    'CHF': {
      'locale': 'de_CH',
      'symbol': 'Fr ',
      'decimal': 2,
      'name': 'Swiss Franc',
    },
    'CLP': {
      'locale': 'es_CL',
      'symbol': '\$ ',
      'decimal': 0,
      'name': 'Chilean Peso',
    },
    'CNY': {
      'locale': 'zh_CN',
      'symbol': '¥ ',
      'decimal': 2,
      'name': 'Chinese Yuan',
    },
    'COP': {
      'locale': 'es_CO',
      'symbol': '\$ ',
      'decimal': 2,
      'name': 'Colombian Peso',
    },
    'CRC': {
      'locale': 'es_CR',
      'symbol': '₡ ',
      'decimal': 2,
      'name': 'Costa Rican Colón',
    },
    'CUP': {
      'locale': 'es_CU',
      'symbol': '\$ ',
      'decimal': 2,
      'name': 'Cuban Peso',
    },
    'CVE': {
      'locale': 'pt_CV',
      'symbol': '\$ ',
      'decimal': 2,
      'name': 'Cape Verdean Escudo',
    },
    'CZK': {
      'locale': 'cs_CZ',
      'symbol': 'Kč ',
      'decimal': 2,
      'name': 'Czech Koruna',
    },
    'DJF': {
      'locale': 'fr_DJ',
      'symbol': 'Fr ',
      'decimal': 0,
      'name': 'Djiboutian Franc',
    },
    'DKK': {
      'locale': 'da_DK',
      'symbol': 'kr ',
      'decimal': 2,
      'name': 'Danish Krone',
    },
    'DOP': {
      'locale': 'es_DO',
      'symbol': 'RD\$ ',
      'decimal': 2,
      'name': 'Dominican Peso',
    },
    'DZD': {
      'locale': 'ar_DZ',
      'symbol': 'دج ',
      'decimal': 2,
      'name': 'Algerian Dinar',
    },
    'EGP': {
      'locale': 'ar_EG',
      'symbol': '£ ',
      'decimal': 2,
      'name': 'Egyptian Pound',
    },
    'ERN': {
      'locale': 'ti_ER',
      'symbol': 'Nfk ',
      'decimal': 2,
      'name': 'Eritrean Nakfa',
    },
    'ETB': {
      'locale': 'am_ET',
      'symbol': 'Br ',
      'decimal': 2,
      'name': 'Ethiopian Birr',
    },
    'EUR': {'locale': 'de_DE', 'symbol': '€ ', 'decimal': 2, 'name': 'Euro'},
    'FJD': {
      'locale': 'en_FJ',
      'symbol': 'FJ\$ ',
      'decimal': 2,
      'name': 'Fijian Dollar',
    },
    'FKP': {
      'locale': 'en_FK',
      'symbol': 'FK£ ',
      'decimal': 2,
      'name': 'Falkland Islands Pound',
    },
    'GBP': {
      'locale': 'en_GB',
      'symbol': '£ ',
      'decimal': 2,
      'name': 'British Pound',
    },
    'GEL': {
      'locale': 'ka_GE',
      'symbol': '₾ ',
      'decimal': 2,
      'name': 'Georgian Lari',
    },
    'GHS': {
      'locale': 'ak_GH',
      'symbol': '₵ ',
      'decimal': 2,
      'name': 'Ghanaian Cedi',
    },
    'GIP': {
      'locale': 'en_GI',
      'symbol': '£ ',
      'decimal': 2,
      'name': 'Gibraltar Pound',
    },
    'GMD': {
      'locale': 'en_GM',
      'symbol': 'D ',
      'decimal': 2,
      'name': 'Gambian Dalasi',
    },
    'GNF': {
      'locale': 'fr_GN',
      'symbol': 'Fr ',
      'decimal': 0,
      'name': 'Guinean Franc',
    },
    'GTQ': {
      'locale': 'es_GT',
      'symbol': 'Q ',
      'decimal': 2,
      'name': 'Guatemalan Quetzal',
    },
    'GYD': {
      'locale': 'en_GY',
      'symbol': 'GY\$ ',
      'decimal': 2,
      'name': 'Guyanese Dollar',
    },
    'HKD': {
      'locale': 'zh_HK',
      'symbol': 'HK\$ ',
      'decimal': 2,
      'name': 'Hong Kong Dollar',
    },
    'HNL': {
      'locale': 'es_HN',
      'symbol': 'L ',
      'decimal': 2,
      'name': 'Honduran Lempira',
    },
    'HRK': {
      'locale': 'hr_HR',
      'symbol': 'kn ',
      'decimal': 2,
      'name': 'Croatian Kuna',
    },
    'HTG': {
      'locale': 'fr_HT',
      'symbol': 'G ',
      'decimal': 2,
      'name': 'Haitian Gourde',
    },
    'HUF': {
      'locale': 'hu_HU',
      'symbol': 'Ft ',
      'decimal': 2,
      'name': 'Hungarian Forint',
    },
    'IDR': {
      'locale': 'id_ID',
      'symbol': 'Rp ',
      'decimal': 0,
      'name': 'Indonesian Rupiah',
    },
    'ILS': {
      'locale': 'he_IL',
      'symbol': '₪ ',
      'decimal': 2,
      'name': 'Israeli New Shekel',
    },
    'INR': {
      'locale': 'en_IN',
      'symbol': '₹ ',
      'decimal': 2,
      'name': 'Indian Rupee',
    },
    'IQD': {
      'locale': 'ar_IQ',
      'symbol': 'ع.د ',
      'decimal': 3,
      'name': 'Iraqi Dinar',
    },
    'IRR': {
      'locale': 'fa_IR',
      'symbol': '﷼ ',
      'decimal': 2,
      'name': 'Iranian Rial',
    },
    'ISK': {
      'locale': 'is_IS',
      'symbol': 'kr ',
      'decimal': 0,
      'name': 'Icelandic Króna',
    },
    'JMD': {
      'locale': 'en_JM',
      'symbol': 'J\$ ',
      'decimal': 2,
      'name': 'Jamaican Dollar',
    },
    'JOD': {
      'locale': 'ar_JO',
      'symbol': 'JD ',
      'decimal': 3,
      'name': 'Jordanian Dinar',
    },
    'JPY': {
      'locale': 'ja_JP',
      'symbol': '¥ ',
      'decimal': 0,
      'name': 'Japanese Yen',
    },
    'KES': {
      'locale': 'sw_KE',
      'symbol': 'KSh ',
      'decimal': 2,
      'name': 'Kenyan Shilling',
    },
    'KGS': {
      'locale': 'ky_KG',
      'symbol': 'лв ',
      'decimal': 2,
      'name': 'Kyrgystani Som',
    },
    'KHR': {
      'locale': 'km_KH',
      'symbol': '៛ ',
      'decimal': 2,
      'name': 'Cambodian Riel',
    },
    'KMF': {
      'locale': 'ar_KM',
      'symbol': 'Fr ',
      'decimal': 0,
      'name': 'Comorian Franc',
    },
    'KPW': {
      'locale': 'ko_KP',
      'symbol': '₩ ',
      'decimal': 2,
      'name': 'North Korean Won',
    },
    'KRW': {
      'locale': 'ko_KR',
      'symbol': '₩ ',
      'decimal': 0,
      'name': 'South Korean Won',
    },
    'KWD': {
      'locale': 'ar_KW',
      'symbol': 'KD ',
      'decimal': 3,
      'name': 'Kuwaiti Dinar',
    },
    'KYD': {
      'locale': 'en_KY',
      'symbol': 'CI\$ ',
      'decimal': 2,
      'name': 'Cayman Islands Dollar',
    },
    'KZT': {
      'locale': 'kk_KZ',
      'symbol': '₸ ',
      'decimal': 2,
      'name': 'Kazakhstani Tenge',
    },
    'LAK': {
      'locale': 'lo_LA',
      'symbol': '₭ ',
      'decimal': 2,
      'name': 'Laotian Kip',
    },
    'LBP': {
      'locale': 'ar_LB',
      'symbol': 'ل.ل ',
      'decimal': 2,
      'name': 'Lebanese Pound',
    },
    'LKR': {
      'locale': 'si_LK',
      'symbol': '₨ ',
      'decimal': 2,
      'name': 'Sri Lankan Rupee',
    },
    'LRD': {
      'locale': 'en_LR',
      'symbol': 'L\$ ',
      'decimal': 2,
      'name': 'Liberian Dollar',
    },
    'LSL': {
      'locale': 'st_LS',
      'symbol': 'L ',
      'decimal': 2,
      'name': 'Lesotho Loti',
    },
    'LYD': {
      'locale': 'ar_LY',
      'symbol': 'LD ',
      'decimal': 3,
      'name': 'Libyan Dinar',
    },
    'MAD': {
      'locale': 'ar_MA',
      'symbol': 'MAD ',
      'decimal': 2,
      'name': 'Moroccan Dirham',
    },
    'MDL': {
      'locale': 'ro_MD',
      'symbol': 'L ',
      'decimal': 2,
      'name': 'Moldovan Leu',
    },
    'MGA': {
      'locale': 'mg_MG',
      'symbol': 'Ar ',
      'decimal': 2,
      'name': 'Malagasy Ariary',
    },
    'MKD': {
      'locale': 'mk_MK',
      'symbol': 'ден ',
      'decimal': 2,
      'name': 'Macedonian Denar',
    },
    'MMK': {
      'locale': 'my_MM',
      'symbol': 'K ',
      'decimal': 2,
      'name': 'Myanmar Kyat',
    },
    'MNT': {
      'locale': 'mn_MN',
      'symbol': '₮ ',
      'decimal': 2,
      'name': 'Mongolian Tögrög',
    },
    'MOP': {
      'locale': 'zh_MO',
      'symbol': 'P ',
      'decimal': 2,
      'name': 'Macanese Pataca',
    },
    'MRU': {
      'locale': 'ar_MR',
      'symbol': 'UM ',
      'decimal': 2,
      'name': 'Mauritanian Ouguiya',
    },
    'MUR': {
      'locale': 'en_MU',
      'symbol': '₨ ',
      'decimal': 2,
      'name': 'Mauritian Rupee',
    },
    'MVR': {
      'locale': 'dv_MV',
      'symbol': 'Rf ',
      'decimal': 2,
      'name': 'Maldivian Rufiyaa',
    },
    'MWK': {
      'locale': 'en_MW',
      'symbol': 'MK ',
      'decimal': 2,
      'name': 'Malawian Kwacha',
    },
    'MXN': {
      'locale': 'es_MX',
      'symbol': 'MX\$ ',
      'decimal': 2,
      'name': 'Mexican Peso',
    },
    'MYR': {
      'locale': 'ms_MY',
      'symbol': 'RM ',
      'decimal': 2,
      'name': 'Malaysian Ringgit',
    },
    'MZN': {
      'locale': 'pt_MZ',
      'symbol': 'MT ',
      'decimal': 2,
      'name': 'Mozambican Metical',
    },
    'NAD': {
      'locale': 'en_NA',
      'symbol': 'N\$ ',
      'decimal': 2,
      'name': 'Namibian Dollar',
    },
    'NGN': {
      'locale': 'en_NG',
      'symbol': '₦ ',
      'decimal': 2,
      'name': 'Nigerian Naira',
    },
    'NIO': {
      'locale': 'es_NI',
      'symbol': 'C\$ ',
      'decimal': 2,
      'name': 'Nicaraguan Córdoba',
    },
    'NOK': {
      'locale': 'nb_NO',
      'symbol': 'kr ',
      'decimal': 2,
      'name': 'Norwegian Krone',
    },
    'NPR': {
      'locale': 'ne_NP',
      'symbol': '₨ ',
      'decimal': 2,
      'name': 'Nepalese Rupee',
    },
    'NZD': {
      'locale': 'en_NZ',
      'symbol': 'NZ\$ ',
      'decimal': 2,
      'name': 'New Zealand Dollar',
    },
    'OMR': {
      'locale': 'ar_OM',
      'symbol': 'ر.ع. ',
      'decimal': 3,
      'name': 'Omani Rial',
    },
    'PAB': {
      'locale': 'es_PA',
      'symbol': 'B/. ',
      'decimal': 2,
      'name': 'Panamanian Balboa',
    },
    'PEN': {
      'locale': 'es_PE',
      'symbol': 'S/. ',
      'decimal': 2,
      'name': 'Peruvian Sol',
    },
    'PGK': {
      'locale': 'en_PG',
      'symbol': 'K ',
      'decimal': 2,
      'name': 'Papua New Guinean Kina',
    },
    'PHP': {
      'locale': 'fil_PH',
      'symbol': '₱ ',
      'decimal': 2,
      'name': 'Philippine Peso',
    },
    'PKR': {
      'locale': 'ur_PK',
      'symbol': '₨ ',
      'decimal': 2,
      'name': 'Pakistani Rupee',
    },
    'PLN': {
      'locale': 'pl_PL',
      'symbol': 'zł ',
      'decimal': 2,
      'name': 'Polish Złoty',
    },
    'PYG': {
      'locale': 'es_PY',
      'symbol': '₲ ',
      'decimal': 0,
      'name': 'Paraguayan Guaraní',
    },
    'QAR': {
      'locale': 'ar_QA',
      'symbol': 'ر.ق ',
      'decimal': 2,
      'name': 'Qatari Riyal',
    },
    'RON': {
      'locale': 'ro_RO',
      'symbol': 'Lei ',
      'decimal': 2,
      'name': 'Romanian Leu',
    },
    'RSD': {
      'locale': 'sr_RS',
      'symbol': 'дин. ',
      'decimal': 2,
      'name': 'Serbian Dinar',
    },
    'RUB': {
      'locale': 'ru_RU',
      'symbol': '₽ ',
      'decimal': 2,
      'name': 'Russian Ruble',
    },
    'RWF': {
      'locale': 'rw_RW',
      'symbol': 'Fr ',
      'decimal': 0,
      'name': 'Rwandan Franc',
    },
    'SAR': {
      'locale': 'ar_SA',
      'symbol': 'ر.س ',
      'decimal': 2,
      'name': 'Saudi Riyal',
    },
    'SBD': {
      'locale': 'en_SB',
      'symbol': 'SI\$ ',
      'decimal': 2,
      'name': 'Solomon Islands Dollar',
    },
    'SCR': {
      'locale': 'en_SC',
      'symbol': '₨ ',
      'decimal': 2,
      'name': 'Seychellois Rupee',
    },
    'SDG': {
      'locale': 'ar_SD',
      'symbol': 'ج.س. ',
      'decimal': 2,
      'name': 'Sudanese Pound',
    },
    'SEK': {
      'locale': 'sv_SE',
      'symbol': 'kr ',
      'decimal': 2,
      'name': 'Swedish Krona',
    },
    'SGD': {
      'locale': 'en_SG',
      'symbol': 'S\$ ',
      'decimal': 2,
      'name': 'Singapore Dollar',
    },
    'SHP': {
      'locale': 'en_SH',
      'symbol': '£ ',
      'decimal': 2,
      'name': 'Saint Helena Pound',
    },
    'SLL': {
      'locale': 'en_SL',
      'symbol': 'Le ',
      'decimal': 2,
      'name': 'Sierra Leonean Leone',
    },
    'SOS': {
      'locale': 'so_SO',
      'symbol': 'Sh ',
      'decimal': 2,
      'name': 'Somali Shilling',
    },
    'SRD': {
      'locale': 'nl_SR',
      'symbol': '\$ ',
      'decimal': 2,
      'name': 'Surinamese Dollar',
    },
    'STN': {
      'locale': 'pt_ST',
      'symbol': 'Db ',
      'decimal': 2,
      'name': 'São Tomé & Príncipe Dobra',
    },
    'SVC': {
      'locale': 'es_SV',
      'symbol': '₡ ',
      'decimal': 2,
      'name': 'Salvadoran Colón',
    },
    'SYP': {
      'locale': 'ar_SY',
      'symbol': '£ ',
      'decimal': 2,
      'name': 'Syrian Pound',
    },
    'SZL': {
      'locale': 'en_SZ',
      'symbol': 'L ',
      'decimal': 2,
      'name': 'Swazi Lilangeni',
    },
    'THB': {
      'locale': 'th_TH',
      'symbol': '฿ ',
      'decimal': 2,
      'name': 'Thai Baht',
    },
    'TJS': {
      'locale': 'tg_TJ',
      'symbol': 'SM ',
      'decimal': 2,
      'name': 'Tajikistani Somoni',
    },
    'TMT': {
      'locale': 'tk_TM',
      'symbol': 'T ',
      'decimal': 2,
      'name': 'Turkmenistani Manat',
    },
    'TND': {
      'locale': 'ar_TN',
      'symbol': 'د.ت ',
      'decimal': 3,
      'name': 'Tunisian Dinar',
    },
    'TOP': {
      'locale': 'to_TO',
      'symbol': 'T\$ ',
      'decimal': 2,
      'name': 'Tongan Paʻanga',
    },
    'TRY': {
      'locale': 'tr_TR',
      'symbol': '₺ ',
      'decimal': 2,
      'name': 'Turkish Lira',
    },
    'TTD': {
      'locale': 'en_TT',
      'symbol': 'TT\$ ',
      'decimal': 2,
      'name': 'Trinidad & Tobago Dollar',
    },
    'TVD': {
      'locale': 'en_TV',
      'symbol': '\$ ',
      'decimal': 2,
      'name': 'Tuvaluan Dollar',
    },
    'TWD': {
      'locale': 'zh_TW',
      'symbol': 'NT\$ ',
      'decimal': 2,
      'name': 'New Taiwan Dollar',
    },
    'TZS': {
      'locale': 'sw_TZ',
      'symbol': 'Sh ',
      'decimal': 2,
      'name': 'Tanzanian Shilling',
    },
    'UAH': {
      'locale': 'uk_UA',
      'symbol': '₴ ',
      'decimal': 2,
      'name': 'Ukrainian Hryvnia',
    },
    'UGX': {
      'locale': 'sw_UG',
      'symbol': 'Sh ',
      'decimal': 0,
      'name': 'Ugandan Shilling',
    },
    'USD': {
      'locale': 'en_US',
      'symbol': '\$ ',
      'decimal': 2,
      'name': 'US Dollar',
    },
    'UYU': {
      'locale': 'es_UY',
      'symbol': '\$U ',
      'decimal': 2,
      'name': 'Uruguayan Peso',
    },
    'UZS': {
      'locale': 'uz_UZ',
      'symbol': 'лв ',
      'decimal': 2,
      'name': 'Uzbekistani Som',
    },
    'VES': {
      'locale': 'es_VE',
      'symbol': 'Bs.S ',
      'decimal': 2,
      'name': 'Venezuelan Bolívar',
    },
    'VND': {
      'locale': 'vi_VN',
      'symbol': '₫ ',
      'decimal': 0,
      'name': 'Vietnamese Dong',
    },
    'VUV': {
      'locale': 'bi_VU',
      'symbol': 'Vt ',
      'decimal': 0,
      'name': 'Vanuatu Vatu',
    },
    'WST': {
      'locale': 'en_WS',
      'symbol': 'T ',
      'decimal': 2,
      'name': 'Samoan Tālā',
    },
    'XAF': {
      'locale': 'fr_CM',
      'symbol': 'Fr ',
      'decimal': 0,
      'name': 'Central African CFA Franc',
    },
    'XCD': {
      'locale': 'en_AG',
      'symbol': 'EC\$ ',
      'decimal': 2,
      'name': 'East Caribbean Dollar',
    },
    'XOF': {
      'locale': 'fr_SN',
      'symbol': 'Fr ',
      'decimal': 0,
      'name': 'West African CFA Franc',
    },
    'XPF': {
      'locale': 'fr_PF',
      'symbol': 'Fr ',
      'decimal': 0,
      'name': 'CFP Franc',
    },
    'YER': {
      'locale': 'ar_YE',
      'symbol': '﷼ ',
      'decimal': 2,
      'name': 'Yemeni Rial',
    },
    'ZAR': {
      'locale': 'en_ZA',
      'symbol': 'R ',
      'decimal': 2,
      'name': 'South African Rand',
    },
    'ZMW': {
      'locale': 'en_ZM',
      'symbol': 'ZK ',
      'decimal': 2,
      'name': 'Zambian Kwacha',
    },
    'ZWL': {
      'locale': 'en_ZW',
      'symbol': 'Z\$ ',
      'decimal': 2,
      'name': 'Zimbabwean Dollar',
    },
  };

  static String format(double amount, {String currency = 'IDR'}) {
    final config = _currencyConfigs[currency] ?? _currencyConfigs['IDR']!;
    try {
      final formatter = NumberFormat.currency(
        locale: config['locale'],
        symbol: config['symbol'],
        decimalDigits: config['decimal'],
      );
      return formatter.format(amount);
    } catch (_) {
      return '${config['symbol']}${amount.toStringAsFixed(config['decimal'])}';
    }
  }

  static String formatCompact(double amount, {String currency = 'IDR'}) {
    final config = _currencyConfigs[currency] ?? _currencyConfigs['IDR']!;
    final symbol = config['symbol'] as String;
    if (amount >= 1000000000) {
      return '$symbol${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(0)}K';
    }
    return format(amount, currency: currency);
  }

  static List<String> get supportedCurrencies =>
      _currencyConfigs.keys.toList()..sort();

  static String getSymbol(String currency) {
    return (_currencyConfigs[currency]?['symbol'] as String?) ?? 'Rp ';
  }

  static String getName(String currency) {
    return (_currencyConfigs[currency]?['name'] as String?) ?? currency;
  }

  static String getDisplayName(String currency) {
    final name = getName(currency);
    final symbol = getSymbol(currency).trim();
    return '$currency — $name ($symbol)';
  }
}
