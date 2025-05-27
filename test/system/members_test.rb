require "application_system_test_case"

class MembersTest < ApplicationSystemTestCase
  setup do
    @member = members(:one)
  end

  test "visiting the index" do
    visit members_url
    assert_selector "h1", text: "Members"
  end

  test "should create member" do
    visit members_url
    click_on "Add New Member"

    fill_in "Birthday", with: @member.birthday
    fill_in "Current rank", with: @member.current_rank
    fill_in "Email", with: "test_email@example.com"
    fill_in "Games played", with: @member.games_played
    fill_in "Name", with: @member.name
    fill_in "Surname", with: @member.surname
    click_on "Save Changes"

    assert_text "Member was successfully created"
    click_on "Back"
  end

  test "should update Member" do
    visit member_url(@member)
    click_on "Edit this member", match: :first

    fill_in "Birthday", with: @member.birthday
    fill_in "Current rank", with: @member.current_rank
    fill_in "Email", with: @member.email
    fill_in "Games played", with: @member.games_played
    fill_in "Name", with: @member.name
    fill_in "Surname", with: @member.surname
    click_on "Save Changes"

    assert_text "Member was successfully updated"
    click_on "Back"
  end

  test "should destroy Member" do
    visit member_url(@member)
    click_on "Destroy this member", match: :first

    assert_text "Member was successfully destroyed"
  end
end
