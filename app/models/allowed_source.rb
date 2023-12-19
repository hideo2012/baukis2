class AllowedSource < ApplicationRecord
  attr_accessor :_destoy
  attr_reader :last_octet

  def last_octet=(_last_octet)
    # 永久ループ！(ctrlz)  self.last_octet = _last_octet.strip
    @last_octet = _last_octet.strip
    self.octet4 = wildcard_or_last( last_octet )
=begin
    if last_octet == "*"
      self.octet4 = 0
      self.wildcard = true
    else
      self.octet4 = last_octet
    end
=end
  end

=begin
  before_validation do
    if last_octet
      self.last_octet.strip!
      if last_octet == "*"
        self.octet4 = 0
        self.wildcard = true
      else
        self.octet4 = last_octet
      end
    end
  end
=end

  validates :octet1, :octet2, :octet3, :octet4, presence: true,
    numericality: { only_integer: true, allow_blank: true },
    inclusion: { in: 0..255, allow_blank: true }

  validates :octet4,
    uniqueness: {
      scope: [ :namespace, :octet1, :octet2, :octet3 ], allow_blank: true
    }
  validates :last_octet, 
    inclusion: { in: (0..255).to_a.map(&:to_s) + ["*"], allow_blank: true }

  after_validation do
    if last_octet
      errors[:octet4].each do |message|
        errors.add( :last_octet, message )
      end
    end
  end

  def ip_address=(_ip_address)
    octets = _ip_address.split(".")
    self.octet1 = octets[0]
    self.octet2 = octets[1]
    self.octet3 = octets[2]
    self.octet4 = wildcard_or_last( octets[3] )

=begin
    if octets[3] == "*"
      self.octet4 = 0
      self.wildcard = true
    else
      self.octet4 = octets[3]
    end
=end
  end

  private def wildcard_or_last( _last_octet )
    return _last_octet  unless _last_octet == "*"
    self.wildcard = true
    0
  end



  def ip_address
    [ octet1, octet2, octet3, wildcard? ? "*" : octet4 ].join(".")
  end


  class << self
    def include?( _namespace, _ip_address )
      p ">> restrict config :#{Rails.application.config.baukis2[:restrict_ip_address]}"

      if Rails.application.config.baukis2[:restrict_ip_address] == false
        return true # any ip OK ( 0.0.0.0 )
      end

      octets = _ip_address.split(".")

      condition = %Q{
        octet1 = ? AND 
        octet2 = ? AND 
        octet3 = ? AND
        ( (octet4 = ? AND wildcard = false ) OR wildcard = true )
      }.gsub(/\s+/, " ").strip

      opts = [ condition, *octets ]
      where( namespace: _namespace).where(opts).exists?
    end
  end

end
