data = JSON.parse('{"6":{"total":165,"data":[]},"2":{"total":286,"data":[]},"3":{"total":200,"data":[]},"4":{"total":176,"data":[]},"5":{"total":120,"data":[]},"8":{"total":75,"data":[]},"7":{"total":206,"data":[]},"9":{"total":129,"data":[]},"10":{"total":109,"data":[]},"11":{"total":123,"data":[]},"12":{"total":111,"data":[]},"15":{"total":99,"data":[]},"17":{"total":111,"data":[]},"16":{"total":128,"data":[]},"20":{"total":135,"data":[]},"18":{"total":110,"data":[]},"19":{"total":98,"data":[]},"25":{"total":77,"data":[]},"21":{"total":112,"data":[]},"22":{"total":78,"data":[]},"23":{"total":118,"data":[]},"24":{"total":64,"data":[]},"26":{"total":227,"data":[]},"27":{"total":93,"data":[]},"29":{"total":69,"data":[]},"28":{"total":88,"data":[]},"33":{"total":73,"data":[]},"30":{"total":60,"data":[]},"31":{"total":34,"data":[]},"32":{"total":30,"data":[]},"35":{"total":45,"data":[]},"34":{"total":54,"data":[]},"36":{"total":83,"data":[]},"39":{"total":75,"data":[]},"37":{"total":182,"data":[]},"38":{"total":88,"data":[]},"40":{"total":85,"data":[]},"42":{"total":53,"data":[]},"41":{"total":54,"data":[]},"43":{"total":89,"data":[]},"44":{"total":59,"data":[]},"45":{"total":37,"data":[]},"46":{"total":35,"data":[]},"48":{"total":29,"data":[]},"47":{"total":38,"data":[]},"50":{"total":45,"data":[]},"49":{"total":18,"data":[]},"52":{"total":49,"data":[]},"51":{"total":60,"data":[]},"54":{"total":55,"data":[]},"53":{"total":62,"data":[]},"57":{"total":29,"data":[]},"55":{"total":78,"data":[]},"56":{"total":96,"data":[]},"60":{"total":13,"data":[]},"58":{"total":22,"data":[]},"59":{"total":24,"data":[]},"62":{"total":11,"data":[]},"61":{"total":14,"data":[]},"63":{"total":11,"data":[]},"64":{"total":18,"data":[]},"65":{"total":12,"data":[]},"66":{"total":12,"data":[]},"67":{"total":30,"data":[]},"68":{"total":52,"data":[]},"84":{"total":25,"data":[]},"14":{"total":52,"data":[]},"69":{"total":52,"data":[]},"83":{"total":36,"data":[]},"78":{"total":40,"data":[]},"1":{"total":6,"data":[]},"74":{"total":56,"data":[]},"75":{"total":40,"data":[]},"86":{"total":17,"data":[]},"70":{"total":44,"data":[]},"71":{"total":28,"data":[]},"72":{"total":28,"data":[]},"96":{"total":19,"data":[]},"77":{"total":50,"data":[]},"82":{"total":19,"data":[]},"13":{"total":43,"data":[]},"76":{"total":31,"data":[]},"90":{"total":20,"data":[]},"94":{"total":8,"data":[]},"91":{"total":15,"data":[]},"73":{"total":20,"data":[]},"103":{"total":3,"data":[]},"79":{"total":46,"data":[]},"105":{"total":5,"data":[]},"80":{"total":42,"data":[]},"87":{"total":19,"data":[]},"81":{"total":29,"data":[]},"88":{"total":26,"data":[]},"85":{"total":22,"data":[]},"108":{"total":3,"data":[]},"101":{"total":11,"data":[]},"93":{"total":11,"data":[]},"89":{"total":30,"data":[]},"97":{"total":5,"data":[]},"92":{"total":21,"data":[]},"100":{"total":11,"data":[]},"95":{"total":8,"data":[]},"111":{"total":5,"data":[]},"99":{"total":8,"data":[]},"106":{"total":4,"data":[]},"114":{"total":6,"data":[]},"98":{"total":8,"data":[]},"104":{"total":9,"data":[]},"102":{"total":8,"data":[]},"109":{"total":6,"data":[]},"112":{"total":4,"data":[]},"107":{"total":7,"data":[]},"110":{"total":3,"data":[]},"113":{"total":5,"data":[]}}')

data['1']['data'] << {'1' => "بِسۡمِ اللهِ الرَّحۡمٰنِ الرَّحِيۡم ﴿﻿۱﻿﴾"}

def get_text(chapter, verse)
  url = "http://www.quranexplorer.com/quran/Translation.aspx?Page=2&Sura=#{chapter}&FVer=#{verse}&TVer=#{verse}&USize=5.2&ESize=2.2&Script=IndoPak&ACCT=0"
  response = agent.get(url)
  text = response.search("#mspan#{verse+1}").first.text
  puts "text for chapter #{chapter} verse #{verse+1} => #{text}"

  {verse+1 => text}
rescue Exception => e
  binding.pry
end


def agent
  unless @agent
    @agent = Mechanize.new
  end

  @agent
end

data.keys.each do |chapter|
  total = data[chapter]['total']
  0.upto(total-1) do |verse|
    next if verse == 0 && chapter == '1'
    data[chapter]['data'] << get_text(chapter, verse)
  end

  File.open("abc/#{chapter}.json", "wb") do |file|
    file << data.to_json
  end
end
