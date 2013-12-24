module Ottoman
    class NonExistingComment < StandardError
        @@info = { :message => 'comment not found', :status => 404 }

        def status
            @@info[:status]
        end

        def data
            @@info
        end
    end
end
