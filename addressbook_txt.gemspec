Gem::Specification.new do |s|
  s.name = 'addressbook_txt'
  s.version = '0.2.1'
  s.summary = 'Stores address book entries in a plain text file'
  s.authors = ['James Robertson']
  s.files = Dir['lib/addressbook_txt.rb']
  s.add_runtime_dependency('dynarex', '~> 1.7', '>=1.7.14')
  s.add_runtime_dependency('rexle-diff', '~> 0.5', '>=0.5.4')
  s.signing_key = '../privatekeys/addressbook_txt.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/addressbook_txt'
end
