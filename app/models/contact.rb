require 'google_drive_v0'
class Contact
  include ActiveModel::Model
  attr_accessor :name, :string
  attr_accessor :email, :string
  attr_accessor :content, :string
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :content
  validates_length_of :content, :maximum => 500
  
  def update_spreadsheet
    connection = GoogleDriveV0.login(Figaro.env.email_provider_username, Figaro.env.email_provider_password)
    
    ss = connection.spreadsheet_by_title('Learn-Rails_Example')
    if ss.nil?
      ss = connection.create_spreadsheet('Learn-Rails-Example')
    end
    ws = ss.worksheets[0]
    last_row = 1 + ws.num_rows
    ws[last_row, 1] = Time.now
    ws[last_row, 2] = self.name
    ws[last_row, 3] = self.email
    ws[last_row, 4] = self.content
    ws.save
  end
end