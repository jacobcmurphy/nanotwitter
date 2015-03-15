module Sinatra
		module NTAuth
			module Check
				def check(method_name)
					condition do
						send(method_name)
					end
				end
				# could be re-written as: 
				# set(:check) { |method_name| condition {send method_name}}
			end

			module Auth
				def authorized?
					# fill this part in later
				end
			end
		end

	register NTAuth::Check
	helpers  NTAuth::Auth
end
