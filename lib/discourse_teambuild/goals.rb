# frozen_string_literal: true

module DiscourseTeambuild
  module Goals
    def self.team_members
      [
        { id: 100, label: 'Andrew' },
        { id: 101, label: 'Arpit' },
        { id: 102, label: 'Bianca' },
        { id: 103, label: 'Blake' },
        { id: 104, label: 'Dan' },
        { id: 105, label: 'Daniel' },
        { id: 106, label: 'David' },
        { id: 107, label: 'Gen' },
        { id: 108, label: 'Gerhard' },
        { id: 109, label: 'Hawk' },
        { id: 110, label: 'Jarek' },
        { id: 111, label: 'Jeff A.' },
        { id: 112, label: 'Jeff W.' },
        { id: 113, label: 'Joffrey' },
        { id: 114, label: 'Joshua' },
        { id: 115, label: 'Justin' },
        { id: 116, label: 'Michael' },
        { id: 117, label: 'Neil' },
        { id: 118, label: 'Penar' },
        { id: 119, label: 'Rafael' },
        { id: 120, label: 'Régis' },
        { id: 121, label: 'Rishabh' },
        { id: 122, label: 'Robin' },
        { id: 123, label: 'Roman' },
        { id: 124, label: 'Saj' },
        { id: 125, label: 'Sam' },
        { id: 126, label: 'Simon' },
        { id: 127, label: 'Taylor' },
      ]
    end

    def self.activities
      [
        { id: 0, label: 'Make a topic tracking your adventures in Montreal' },
        { id: 1, label: 'Eat a Montreal style bagel :bagel:' },
        { id: 2, label: 'Eat junk food from 4 different continents :candy:' },
        { id: 3, label: 'Hear Sam make a pun :man_facepalming:' },
        { id: 4, label: 'Play a board / card game with a team member :game_die:' },
        { id: 5, label: 'Win a game of Rock/Paper/Scissors :scissors:' },
        { id: 6, label: 'Participate in an optional activity :trophy:' },
        { id: 7, label: 'Give a small gift to another team member :gift:' },
        { id: 8, label: 'Say “Bonjour” to a French speaker (Joffrey, Régis and Penar don’t count) :fr:' },
        { id: 9, label: 'Do something you’ve never done before :tada:' },
        { id: 10, label: 'Perform a Yo Yo trick :yo-yo:' },
        { id: 11, label: 'Wear a Discourse shirt / hat :tshirt:' },
        { id: 12, label: 'Chill out in the common room :sunglasses:' },
        { id: 13, label: 'Eat poutine :fries:' },
        { id: 14, label: 'Take a selfie with a landmark :classical_building:' },
        { id: 15, label: 'Take a group photo :framed_picture:' },
        { id: 16, label: 'Like someone’s post on dev/meta while in the same room as them :nerd_face:' },
        { id: 17, label: 'Collect 5 “High Fives” :wave:' },
        { id: 18, label: 'Learn and sing a French Song :musical_note:' },
        { id: 19, label: 'Taste food that another team member cooked :man_cook: :woman_cook:' },
        { id: 20, label: 'Take a walk in Old Montreal :european_castle:' },
        { id: 21, label: 'Say “Hellooooooooooooooo” to a team member with as many o’s as possible :rofl:' },
        { id: 22, label: 'Photo bomb 2 team members taking a selfie with a landmark :see_no_evil:' },
        { id: 23, label: 'Head to the top of Mount Royal' },
        { id: 24, label: 'Go down a zipline' },
        { id: 25, label: 'Have a jetboat adventure' },
        { id: 26, label: 'Go for a walk on St. Pauls street' },
        { id: 27, label: 'Visit a public market' },
        { id: 28, label: 'Learn a brand new card game from a team member' },
        { id: 29, label: 'Check out the botanical gardens' },
        { id: 30, label: 'Check out arcade MTL' },
      ]
    end

    def self.all
      {
        team_members: team_members,
        activities: activities
      }
    end
  end
end
