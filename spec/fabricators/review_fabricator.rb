Fabricator(:review) do
  description {Faker::Lorem.paragraph(3)}
  ratings {(1..5).to_a.sample}
end