defmodule IprApiWeb.ApplicantView do
  use IprApiWeb, :view
  alias IprApiWeb.ApplicantView

  def render("index.json", %{applicants: applicants}) do
    %{data: render_many(applicants, ApplicantView, "applicant.json"),
      pagination: %{
            page_number: applicants.page_number,
            page_size: applicants.page_size,
            total_pages: applicants.total_pages,
            total_entries: applicants.total_entries
          }}
  end

  def render("show.json", %{applicant: applicant}) do
    %{
      success: true,
      data: render_one(applicant, ApplicantView, "applicant.json")
    }
  end

  def render("success.json", %{applicant: _applicant}) do
    %{success: true}
  end

  def render("applicant.json", %{applicant: applicant}) do
    %{
      ic: applicant.ic,
      email: applicant.email,
      name: applicant.name,
      gender: applicant.gender,
      marital_status: applicant.marital_status,
      dob: applicant.dob,
      pob: applicant.pob,
      income: applicant.income,
      residence_period: applicant.residence_period,
      religion: applicant.religion,
      other_religion: applicant.other_religion,
      phone_no: applicant.phone_no,
      home_no: applicant.home_no,
      address_1: applicant.address_1,
      address_2: applicant.address_2,
      address_3: applicant.address_3,
      postcode: applicant.postcode,
      district: applicant.district,
      other_district: applicant.other_district,
      mukim: applicant.mukim,
      state: applicant.state,
      education_level: applicant.education_level,
      other_education_level: applicant.other_education_level,
      no_of_child: applicant.no_of_child,
      profile_completed: applicant.profile_completed,
      verified_account: applicant.verified_account,
      dockets: applicant.dockets,
      childrens: applicant.childrens,
      spouses: applicant.spouses,
      inserted_at: Timex.format!(applicant.inserted_at, "%d-%m-%Y", :strftime),
    }
  end
end
