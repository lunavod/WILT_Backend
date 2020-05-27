Fabricator(:post) do
  creator { User.first }
  title { Faker::Lorem.unique.sentence}
  text { Faker::Lorem.unique.paragraph(sentence_count: 40) }
  original_text { |attrs| attrs[:text].parameterize }
end