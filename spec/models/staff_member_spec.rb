require 'rails_helper'

RSpec.describe StaffMember, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe "#password=" do
    example "文字列を与えると、hashed_passwordは長さ60の文字列になる" do
      member = StaffMember.new
      member.password = "baukis"
      expect(member.hashed_password).to be_kind_of(String)
      expect(member.hashed_password.size).to eq(60)
    end
    example "nilを与えると、hashed_passwordはnilになる" do
      member = StaffMember.new( hashed_password: "x" )
      member.password = nil
      expect(member.hashed_password).to be_nil
    end
  end

  describe " 値の正規化 " do
    example "email 前後の空白除去 " do
      member = create( :staff_member, email: " test@example.com " )
      expect( member.email ).to eq( "test@example.com" )
    end

    example "emailに含まれる全角英数字記号を半角に変換" do
      member = create( :staff_member, email: "ｔｅｓｔ＠ｅｘａｍｐｌｅ．ｃｏｍ" )
      expect( member.email ).to eq( "test@example.com" )
    end

    example "email 前後の全角スペースを除去 " do
      member = create( :staff_member, email: "\u{3000}test@example.com\u{3000}" )
      expect( member.email ).to eq( "test@example.com" )
    end

    example "family_name_kanaに含まれるひらがなをカタカナに変換" do
      member = create( :staff_member, family_name_kana: "てすと" )
      expect( member.family_name_kana).to eq( "テスト" )
    end

    example "family_name_kanaに含まれる半角カタカナを全角カタカナに変換" do
      member = create( :staff_member, family_name_kana: "ﾃｽﾄ" )
      expect( member.family_name_kana).to eq( "テスト" )
    end
  end


  describe " バリデーション " do
    example " ＠を2個含む email は無効 " do
      member = build( :staff_member, email: "test@@example.com" )
      expect( member ).not_to be_valid
    end

    example " 漢字ひらがなカタカナアルファベットのみを含む family_name は有効 " do
      member = build( :staff_member, family_name: " 山田やまだヤマダYamada " )
      expect( member ).to be_valid
    end

    example " 記号、数字を含む family_name は無効 " do
      member = build( :staff_member, family_name: " 山田やまだヤマダYamada19@# " )
      expect( member ).not_to be_valid
    end

    example " 漢字を含む family_name_kana は無効 " do
      member = build( :staff_member, family_name_kana: " 試験 " )
      expect( member ).not_to be_valid
    end

    example " 長音符を含む family_name_kana は有効 " do
      member = build( :staff_member, family_name_kana: " エリー " )
      expect( member ).to be_valid
    end

    example " 他の職員のメールアドレスと重複した email は無効 " do
      member1 = create( :staff_member ) 
      member2 = build( :staff_member, email: member1.email )
      expect( member2 ).not_to be_valid
    end
  end

end
