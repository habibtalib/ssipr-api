defmodule IprApi.Enums do
  import EctoEnum

  defenum(
    DocketStatusEnum,
    diterima_dan_sedang_diproses: 0,
    disahkan: 1,
    ditandai: 2,
    "diterima_dan_sedang_menunggu_semakan_jmb_/_mc": 3,
    disemak: 4,
    lulus: 5,
    gagal: 6,
    diluluskan_oleh_adun: 7,
    ditolak_oleh_adun: 8,
    disahkan_oleh_selcare: 9,
    tidak_aktif: 10,
    aktif: 11
  )

  defenum(
    ProgramStatusEnum,
    tidak_aktif: 0,
    aktif: 1
  )

  defenum(
    AgencyStatusEnum,
    tidak_aktif: 0,
    aktif: 1
  )
end
