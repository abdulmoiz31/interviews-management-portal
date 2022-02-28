require 'tiny_tds'
class AzureDb
    def initialize()
      server = 'interview-management-portal.database.windows.net'
      database = 'files'
      username = 'madteam'
      password = 'systems123!'
      @client = TinyTds::Client.new username: username, password: password, 
          host: server, port: 1433, database: database, azure: true
    end
    
    def add_file(file)
        tsql = "INSERT INTO [dbo].[files] VALUES ('#{file[:id]}', '#{file[:data]}', '#{file[:name]}');"
        result = @client.execute(tsql)
        result.insert
    end
    
    def update_file(file)
        tsql = "UPDATE [dbo].[files] SET encodedFile = #{file[:data]}, fileName= #{file[:name]} WHERE ID = #{file[:id]};"
        result = @client.execute(tsql)
    end

    def get_file(file_id)
      tsql = "select * from [dbo].[files] where ID = #{file_id}"
      result = @client.execute(tsql)
      result.each do |row|
          puts row
      end
    end
    
end