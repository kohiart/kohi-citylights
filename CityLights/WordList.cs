// Copyright (c) eepmon. All rights reserved. You do not have permission to reproduce, modify, or redistribute this code or its outputs without express permission from the artist.

namespace CityLights;

public sealed class WordList
{
    public static string[] Init(CityLightsParameters parameters)
    {
        var english = new string[7];
        english[0] =
            "Rise,from,fiery,ashes,Reborn,with,burning,desires,Ever,silently,illuminating,Blaze,onward,Without,hesitation,/,朝♥♥,Ʒ,▓▓▓,▓▓,=▓,__,_▓,=▓,▓▓,▓▓,██,▀▀▀▀,▀▀▀,▀▀▀▀,▀▀───▀▀57,国づ♥♥♥♥,レソヨ判断ク,の,場,サ強,依仰巣,ぞル。";
        english[1] =
            "Momentum,is,key,Perpetually,flowing,infinitely,Manifest,any,form,Kinetically,and,expansively,Become,a,force,to,be,reckoned,/,§§,§§¶,¶§¶§,─,─────▀▀▀,▀▀▀───,───────▀▀,▓▓▓,▓▓,=▓,__,__▓,=▓,▓▓,▓▓,▀▀▀▀▀,──,─,───▀▀▀▀,▀▀▀,▀▀▀▀,▀▀───▀▀▀,▀▀▀▀▀,▀▀,▀▀▀";
        english[2] =
            "Centre,of,gravity,by,the,universe,within,Grounded,through,holistic,reflection,Rooted, by,oneness,Aligned,by,strong,foundations,Unshakable,/,÷÷,Ӝ̵̨̄,Ʒ,▓▓▓,▓▓,=▓,__,__▓,=▓,▓▓,▓▓,██,▀▀▀▀,▀▀▀,▀▀▀▀,▀▀───▀▀▀";
        english[3] =
            "Winds,propel,high,into,the,unknown,Swiftly,taken,by,the,wings,of,time,Reminiscing,on,past,journeys,Uplift,and,forward,to,the,undiscovered,Freedom,to,explore,/,▀▀▀,▀▀,▀,▒▒▒▒,▓▒,▒,▒▀▓,▀▓,▓▓,▓▓,▀▀▀▀▀,▓▓▓,▓▓▓,▀▀▀▀,▀▀▀,▀▀▀▀,▒▀▓,▒▀▓,▒▀▓,●,▓▒▓▒";
        english[4] =
            "Embellished,by,the,elementals,Natural,invitation,and,unassuming,Nurturing,the,world,with,its,timeless,grace,With,the,warmth,at,its,touch,Calming,/,▓,▓▓,▓▓,██,▀▀,¶¶,▀▀,¶¶¶,###,¶¶,¶#,¶¶¶¶¶,FF,1,A7,2E6,¶¶¶¶¶,§§,▒▒▒▒,▓▒,▒,▒▀▓,§§,§§¶,¶§¶§";
        english[5] =
            "Hardening,like,armour,Glimmer,in,darkness,High,frequency,at,peek,energy,Masterfully,calm,Confident,Impenetrable,Fortress,/,¨÷ö¨,©©©,®®,###,œ,¶#,šššš,▓▓,▓▓,██,¶¶¶¶¶,§§,€€€,¾,Ø,▒▀▓,§§,§§¶,¶§¶§,ö,ööö,▓▓,▓▓,██";
        english[6] =
            "Visions,foretold,yet,What,appears,may,not,be,what,seems,Rather,Let,go,constraints,Let,go,all,bias,notions,Embellish,by,spectrum,fluctuations,Of,the,Virtual,and,the,Physical,Between,realities,Liberty,/,ΞΞΞ,ŸŸŸ,∂,▓▓,▓▓,██,▓▓,▓▓,██,œ,∃,∏∏,FF,√√√√,▓▒▓▒,A7,2E6,≡≡,§§,€€€,¾,Ø,▒▀▓,♥♥♥♥,♠♠♠,♣,♦,ööö";

        var japanese = new string[7];
        japanese[0] =
            "もえた,あとの,はいか,,らのぼ,り,もえる,ような,よくぼ,うとと,もにう,まれか,わる,かすか,なひか,り,すすみ,つづ,ける,ためら,うこと,なく,/,朝♥♥,Ʒ,▓▓▓,▓▓,=▓,__,_▓,=▓,▓▓,▓▓,██,▀▀▀▀,▀▀▀,▀▀▀▀,▀▀───▀▀57,国づ♥♥♥♥,レソヨ判断ク,の,場,サ強,依仰巣,ぞル。";
        japanese[1] =
            "いきお,いがか,ぎえいえ,んにむ,げんに,ながれ,る,どんな,ものに,でもな,れる,どうり,きがく,てきに、,そして、,かくちょ,うてきに,ちから,づよい,パワーと,なる,/,§§,§§¶,¶§¶§,─,─────▀▀▀,▀▀▀───,───────▀▀,▓▓▓,▓▓,=▓,__,__▓,=▓,▓▓,▓▓,▀▀▀▀▀,──,─,───▀▀▀▀,▀▀▀,▀▀▀▀,▀▀───▀▀▀,▀▀▀▀▀,▀▀,▀▀▀";
        japanese[2] =
            "うちゅ,うのな,かにあ,るじゅ,うりょく,ぜんた,いてき,なはん,しゃ,わんね,すにね,づいた,ちから,づよい,どだい,にささ,えられ,ている,ゆるぎ,なく,/,÷÷,Ӝ,Ʒ,▓▓▓,▓▓,=▓,__,__▓,=▓,▓▓,▓▓,██,▀▀▀▀,▀▀▀,▀▀▀▀,▀▀───▀▀▀";
        japanese[3] =
            "かぜは,みちへ,とたか,くすす,ませる,ときが,ながれ,る,かこの,たびを,おもい,だしな,がら,みちへ,とじょ,うしょ,うしぜ,んしん,する,たんけ,んする,じゆう,/,▀▀▀,▀▀,▀,▒▒▒▒,▓▒,▒,▒▀▓,▀▓,▓▓,▓▓,▀▀▀▀▀,▓▓▓,▓▓▓,▀▀▀▀,▀▀▀,▀▀▀▀,▒▀▓,▒▀▓,▒▀▓,●,▓▒▓▒";
        japanese[4] =
            "しぜん,のまま,にいろ,どられ,た,しぜん,なさそ,い、そし,てひか,えめに,じだい,をこえ,たうつ,くしさ,でせか,いをつ,つみ,ふれた,ときのあ,たたか,さで,おだや,かに,/,,▓,▓▓,▓▓,██,▀▀,¶¶,▀▀,¶¶¶,###,¶¶,¶#,¶¶¶¶¶,FF,1,A7,2E6,¶¶¶¶¶,§§,▒▒▒▒,▓▒,▒,▒▀▓,§§,§§¶,¶§¶§";
        japanese[5] =
            "よろい,のよう,なかた,さ,くらや,みのな,かのか,すかな,ひかり,たかい,えねる,ぎー,みごと,なおち,つき,じしん,にみち,た,はい,りこめ,ないと,りで,/,¨÷ö¨,©©©,®®,###,œ,¶#,šššš,▓▓,▓▓,██,¶¶¶¶¶,§§,€€€,¾,Ø,▒▀▓,§§,§§¶,¶§¶§,ö,ööö,▓▓,▓▓,██";
        japanese[6] =
            "よこくさ,れたび,じょん,は,みえる,とおりに,あらわ,れない,かもし,れない,それよ,りもい,っそ,せいげ,んをて,ばなそ,う,すべて,のかた,よったかん,がえを,てばな,そう,かそう,とぶっしつ,げんじ,つとの,はざま,じゆ,う,/,ΞΞΞ,ŸŸŸ,∂,▓▓,▓▓,██,▓▓,▓▓,██,œ,∃,∏∏,FF,√√√√,▓▒▓▒,A7,2E6,≡≡,§§,€€€,¾,Ø,▒▀▓,♥♥♥♥,♠♠♠,♣,♦,ööö";

        var listOfWords = parameters.Language == Language.Jp ? japanese : english;
        var hatchedWords = parameters.Element switch
        {
            Element.Fire => listOfWords[0],
            Element.Water => listOfWords[1],
            Element.Earth => listOfWords[2],
            Element.Wind => listOfWords[3],
            Element.Wood => listOfWords[4],
            Element.Metal => listOfWords[5],
            Element.Hologram => listOfWords[6],
            _ => throw new IndexOutOfRangeException()
        };

        return hatchedWords.Split(new[] {','}, StringSplitOptions.RemoveEmptyEntries).ToArray();
    }
}