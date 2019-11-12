defmodule IprApi.Email do
  use Bamboo.Phoenix, view: IprApiWeb.EmailView

  alias Phoenix.Naming

  @admin_url System.get_env("ADMIN_URL") || "http://localhost:3001"

  def email_verification(applicant, link) do
    base()
    |> to(applicant.email)
    |> subject("SSIPR - Selamat Datang!")
    |> render("email_verification.html", link: link)
  end

  def reset_pass(applicant, link) do
    base()
    |> to(applicant.email)
    |> subject("SSIPR - Penetapan Semula Kata Laluan")
    |> render("reset_pass.html", link: link)
  end

  def new_jmb(application, token) do
    jmb_email = application.jmb_confirmation.jmb_email
    applicant = application.applicant

    base()
    |> to(jmb_email)
    |> subject(
      "[IPRSADE#{application.id}] SEMAKAN MAKLUMAT PEMOHON BAGI PERMOHONAN SKIM AIR DARUL EHSAN - #{
        String.upcase(applicant.name)
      }"
    )
    |> render("new_jmb.html",
      link: "#{@admin_url}/ipr_confirmation?token=#{token}",
      applicant: applicant,
      address: complete_address(applicant),
      token: token
    )
  end

  def new_jmb_by_admin(application) do
    jmb_email = application.jmb_confirmation.jmb_email
    applicant = application.applicant

    base()
    |> to(jmb_email)
    |> subject(
      "[IPRSADE#{application.id}] PEMBERITAHUAN SEMAKAN PERMOHONAN PROGRAM SKIM AIR DARUL EHSAN - #{
        String.upcase(applicant.name)
      }"
    )
    |> render("new_jmb_by_admin.html",
      applicant: applicant,
      address: complete_address(applicant)
    )
  end

  def responded_jmb_to_jmb(application) do
    jmb_email = application.jmb_confirmation.jmb_email
    applicant = application.applicant

    base()
    |> to(jmb_email)
    |> cc("iprair@airselangor.com")
    |> subject(
      "[IPRSADE#{application.id}] PEMBERITAHUAN SEMAKAN PERMOHONAN PROGRAM SKIM AIR DARUL EHSAN - #{
        String.upcase(applicant.name)
      }"
    )
    |> render("responded_jmb_to_jmb.html",
      applicant: applicant,
      address: complete_address(applicant)
    )
  end

  def responded_jmb_to_applicant(application) do
    applicant = application.applicant
    jmb_name = application.jmb_confirmation.jmb_name

    base()
    |> to(applicant.email)
    |> cc("iprair@airselangor.com")
    |> subject(
      "[IPRSADE#{application.id}] STATUS SEMAKAN MAKLUMAT PEMOHON OLEH PIHAK JMB - #{
        String.upcase(jmb_name)
      }"
    )
    |> render("responded_jmb_to_applicant.html")
  end

  def new_air_selangor(application) do
    applicant = application.applicant
    status = Naming.humanize(application.status)
    email = if applicant.rep_email, do: applicant.rep_email, else: applicant.email
    subject = "[IPRSADE#{application.id}] PERMOHONAN PROGRAM IPR SKIM AIR DARUL EHSAN - #{
        String.upcase(applicant.name)
      }"

    content =
      if application.residence.meter_type == "pukal" && application.by_admin == false do
        "Dengan hormatnya, ingin dimaklumkan, permohonan Program IPR Skim Air Darul Ehsan anda telah diterima dan menunggu semakan daripada pihak JMB."
      else
        "Dengan hormatnya, ingin dimaklumkan, Permohonan Program IPR Skim Air Darul Ehsan anda telah diterima dan sedang diproses."
      end

    base()
    |> to(email)
    |> cc("iprair@airselangor.com")
    |> subject(
      subject
    )
    |> render("new_air_selangor.html",
      content: content,
      status: String.upcase(status)
    )
  end

  def new_ipr(application) do
    applicant = application.applicant
    status = Naming.humanize(application.status)
    email = if applicant.rep_email, do: applicant.rep_email, else: applicant.email
    subject = "[IPRKISS#{application.id}] PERMOHONAN PROGRAM IPR KASIH IBU SMART SELANGOR - #{
        String.upcase(applicant.name)
      }"

    content = "Dengan hormatnya, ingin dimaklumkan, Permohonan Program IPR KASIH IBU SMART SELANGOR anda telah diterima dan sedang diproses."

    base()
    |> to(email)
    # |> cc("iprair@airselangor.com")
    |> subject(
      subject
    )
    |> render("new_air_selangor.html",
      content: content,
      status: String.upcase(status)
    )
  end

  defp base do
    new_email()
    |> from("ssipr@selangor.gov.my")
    |> put_html_layout({IprApiWeb.LayoutView, "email.html"})
  end

  defp complete_address(applicant) do
    district = if applicant.district == "Lain-lain", do: applicant.other_district, else: applicant.district

    address =
      Enum.reject(
        [
          applicant.address_1,
          applicant.address_2,
          applicant.address_3,
          applicant.postcode,
          district,
          applicant.state
        ],
        &is_nil/1
      )

    address
    |> Enum.join(", ")
  end
end
