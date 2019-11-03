<template>
  <div id="bg">
    <section class="float-bottom">
      <v-layout column wrap class="my-12" align-center>
        <v-flex xs12 sm4 class="my-4">
          <div class="text-center">
            <h1 class="mb-2 display-1 text-center">{{ $t('home.title') }}</h1>
            <h2 class="headline">{{ $t('home.sub-title') }}</h2>
          </div>
        </v-flex>
      </v-layout>
    </section>
    <section class="overHead">
      <v-layout column wrap align-center>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <span class="theMoon" v-on="on">{{ farmingData.moonCode | moonEmojize }}</span>
          </template>
          <span>{{ farmingData.moonString }}</span>
        </v-tooltip>
        <h3 v-if="farmingData.plantingTime">It's Planting Time!</h3>
        <v-tooltip top>
          <template v-slot:activator="{ on }">
            <span class="theEarth" v-on="on">{{ farmingData.what2Plant | earthEmojize }}</span>
          </template>
          <span>{{ farmingData.farmingString }}</span>
        </v-tooltip>
        <p class="text-center"  v-if="farmingData.plantingTime">{{ farmingData.what2Plant }}</p>
      </v-layout>
    </section>
  </div>
</template>
<style scoped>
* {
  color: white;
}
.float-bottom {
  position: relative;
  bottom: -49vh;
}
.overHead{
  position: absolute;
  top: 5%;
  left: 0;
  right: 0;
}
.theMoon{
  font-size: 12vh
}
.theEarth{
  font-size: 6vh
}
#bg {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: black; /* For browsers that do not support gradients */
  background-image: linear-gradient(
    #4444ff,
    #222299,
    black
  ); /* (Top -> Bottom) */
}
</style>
<script>
const axios = require("axios");
var emoji = require("node-emoji");
import { mapState } from 'vuex'
function getCssValuePrefix(){
    var rtrnVal = '';//default to standard syntax
    var prefixes = ['-o-', '-ms-', '-moz-', '-webkit-'];
    // Create a temporary DOM object for testing
    var dom = document.createElement('div');
    for (var i = 0; i < prefixes.length; i++)
    {
        // Attempt to set the style
        dom.style.background = prefixes[i] + 'linear-gradient(#000000, #ffffff)';
        // Detect if the style was successfully set
        if (dom.style.background)
        {
            rtrnVal = prefixes[i];
        }
    }
    dom = null;
    return rtrnVal;
}
export default {
  head () {
    return {
        title: 'agr❤️'
    }
  },
  async fetch({ store, params }) {
    let { data } = await axios.get("https://sriveros95.o6s.io/moon-farmer");
    store.commit("setFarmingData", data);
  },
  computed: mapState({
    farmingData: state => state.farmingData
  }),
  mounted(){
    console.log("hola");
    console.log(this.farmingData);
    var bg = document.getElementById("bg");
    // bg.style["background-image"] = "linear-gradient( red, #222299, black );"; 
    // Setting the gradient with the proper prefix
    var lqa = Math.round(this.farmingData.moonLight * 255 / 100)
    var lqb = Math.round(this.farmingData.moonLight * 210 / 100)
    var colorA = "#"+lqa.toString(16) + "99ff"
    var colorB = "#"+lqa.toString(16) + "4299"
    var colorC = "black"
    bg.style.backgroundImage = getCssValuePrefix() + 'linear-gradient('
        + colorA + ', ' + colorB + ', ' + colorC + ')';
    console.log(colorA);
    console.log(colorB);
    console.log(colorC);
    console.log("lola");
  },
  filters: {
    moonEmojize(moonCode) {
      switch (moonCode) {
        case "NW":
          return emoji.get('new_moon')
        case "XG":
          return emoji.get('waxing_gibbous_moon')
          break;
        case "FQ":
          return emoji.get('first_quarter_moon')
        case "XC":
          return emoji.get('waxing_crescent_moon')
        case "FL":
          return emoji.get('full_moon')
        case "NG":
          return emoji.get('waning_gibbous_moon')
        case "LQ":
          return emoji.get('last_quarter_moon')
        case "NC":
          return emoji.get('waning_crescent_moon')
        default:
          return emoji.get('coffee')
      }
    },
    earthEmojize(what2Plant) {
      switch (what2Plant) {
        case "Above ground annuals, especially Leaf plants also Cereals, Herbs, Cucumbers":
          return emoji.emojify(':seedling: :ear_of_rice: :herb: :cucumber:')
        case "Below ground plants, especially Root plants, Plant trees, shrubs and perennials.":
          return emoji.emojify(':evergreen_tree: :potato: :deciduous_tree: :carrot:"')
        default:
          return ""
      }
    }
  }
};
</script>