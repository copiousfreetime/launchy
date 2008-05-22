module Launchy
    class Version
        MAJOR   = 0
        MINOR   = 3
        BUILD   = 2

        class << self
            def to_a
                [MAJOR, MINOR, BUILD]
            end

            def to_s
                to_a.join(".")
            end
        end
    end
    VERSION = Version.to_s
end
