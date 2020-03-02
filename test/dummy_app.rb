require 'roda'

class DummyApp < Roda
  route do |r|
    r.get '' do
      "hi"
    end
  end
end
