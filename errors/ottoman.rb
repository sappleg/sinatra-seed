module Ottoman
    class OttomanError < StandardError
        @@info = { :message => 'Ottoman fucked up, please contact alan@rescour.com immediately for pissed remarks', :status => 500 }

        def self.status
            @@info[:status]
        end

        def self.data
            @@info
        end
    end
end
