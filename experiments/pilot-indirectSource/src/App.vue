<template>
  <Experiment title="Decision-making experiment">
    <InstructionScreen :title="'Welcome'">
      In this short experiment you will first read a description about a
      fictitious context in which you are supposed to make a decision based on
      some information you received from others. Please read the context
      information very carefully and make your decision deliberately.
      <p></p>
      After your choice, we will ask you to explain your choice in a few words.
    </InstructionScreen>

    <template v-for="(trial, i) of items">
    <Screen label="background">
      <p><strong>Background:</strong> We are now at an age of great exploration and discovery. Humanity has reached the stars, venturing to distant planets in search of new frontiers and resources. One of these new worlds is a remote, resource-rich planet called <strong>Xelifan-3</strong>.</p>

      <p>The year is 2184, and Xelifan-3 has become home to a small but determined group of colonists. Their survival depends on a rare plant known as <strong>Xeliherb</strong>, a life-sustaining resource native to the planet. This unique plant has extraordinary properties, providing essential nutrients necessary for survival on the planet. Furthermore, it holds potential as a key ingredient in medicines capable of curing diseases, which has attracted significant interest from scientists around the galaxy.</p>

      <p>However, xeliherb grows only <strong>sparsely</strong>, and its limited availability has made life on Xelifan-3 a constant struggle.</p>

      <button @click="$magpie.nextScreen();">Next</button>
    </Screen>
    <Screen :key="i">
          <!-- ************************************ -->
           <!-- ************************************ -->
           <Slide v-if="trial.F2_listenerRole === 'scientist'">
            <p>
            You are one of the <strong>scientists</strong>, part of an elite team tasked with uncovering the secrets of <strong>Xeliherb.</strong>
            </p>
            <p>
            Your mission centers on deep exploration of Xeliherb’s properties, with the hope of unlocking its potential for humanity’s future. Each piece of data and sample collected offers new insights into how Xeliherb grows, and what methods might increase its yield over time. From your remote research station, you analyze information sent by the colonists, using scientific expertise to develop techniques that may enhance Xeliherb’s growth and sustainability.
            </p>
            <p>
            However, there is sometimes tension between scientists and colonists. While the scientists pursue deeper understanding and growth strategies, the colonists are focused on immediate survival. Each group’s priorities affect how they view and interpret information about <strong>Xeliherb</strong>. 
            </p>
            <button @click="$magpie.nextSlide();">I'm ready!</button>
          </Slide>
         <!-- ************************************ -->
          <Slide v-if="trial.F2_listenerRole === 'colonist'">
          <p>
            You are one of the <strong>colonists</strong>, part of a determined group that has braved the unknown to settle on Xelifan-3 in search of a new beginning.
          </p>
          <p>
            For the colony, survival depends on securing enough Xeliherb to meet daily needs. Living on the frontlines, you’re closely connected to the land, and every bit of Xeliherb collected is crucial. Your work revolves around locating new patches, gathering as much Xeliherb as possible, and ensuring a steady supply to support the community. The immediate priority is clear: there must be more Xeliherb.
          </p>
          <p>
          However, there is sometimes tension between scientists and colonists. While the scientists pursue deeper understanding and growth strategies, the colonists are focused on immediate survival. Each group’s priorities affect how they view and interpret information about <strong>Xeliherb</strong>. 
          </p>
          <button @click="$magpie.nextSlide();">I'm ready!</button>
          </Slide>
          <!-- ************************************ -->
          <Slide v-if="trial">
          <p>
            <strong>
              As a {{ trial.F2_listenerRole === "scientist" ? "scientist" : "colonist" }}, 
              what is one of your main objectives in working with the {{ trial.F2_listenerRole === "scientist" ? "colonists" : "scientists" }}? 
              (Please select one correct answer)
            </strong>
          </p>

          <MultipleChoiceInput
            :response.sync="$magpie.measurements.attentionCheck"
            :randomize="true"
            :options="[
              'Ensure that there is a steady supply of Xeliherb to meet daily survival needs', 
              'Explore the galaxy for new planets that could be suitable for future colonization', 
              'Ensure that all colonists are motivated and willing to contribute to community projects', 
              'Gather data to uncover patterns in Xeliherb growth that could inform future research'
            ]" 
          />
          <div v-if="$magpie.measurements.attentionCheck !== undefined">
            <p v-if="$magpie.measurements.attentionCheck === correctAnswers[trial.F2_listenerRole]">
              Correct answer! 
            </p>
            <p v-else>
              Please review your objectives again!
            </p>

            <button 
              v-if="$magpie.measurements.attentionCheck === correctAnswers[trial.F2_listenerRole]" 
              @click="$magpie.nextSlide()">
              Next
            </button>
            
            <button 
              v-else 
              @click="$magpie.nextScreen('background')">
              Read again.
            </button>
          </div>
        </Slide>
         <!-- ************************************ -->
         <Slide v-if="trial.F1_informationSource === 'indirect'">
          Now, it is time to make a decision.
<br><br>
While navigating the challenges of life on Xelifan-3, a breakthrough occurs. One evening, a weathered journal is found in the ruins of an old research outpost, a relic from a science team that explored the planet decades ago. The journal is fragile and faded, but its contents are shocking. Here is <strong>what the science team wrote in their journal</strong>:
<br><br>
<strong>The presence of Xeliherb is associatied with another plant called Ralocrop.</strong>
<br><br>
<strong>Question:</strong> How likely are you to cultivate additional Ralocrop?
          <SliderInput
            left="very unlikely"
            right="very likely"
            :response.sync= "$magpie.measurements.probs" />
            {{$magpie.measurements.probs}}%
            <button v-if="$magpie.measurements.probs" @click="$magpie.saveAndNextScreen();">Submit</button>
          <Record
            :data="{
              trialNR: i,
              itemNr: trial.itemNr,
              itemName: trial.itemName,
              condition: trial.condition,
              informationSource: trial.F1_informationSource,
              listenerRole: trial.F2_listenerRole,
              attentionCheckResult: $magpie.measurements.attentionCheck === correctAnswers[trial.F2_listenerRole]
            }"
          />
        </Slide>  
        <!-- ************************************ -->
         <Slide v-if="trial.F1_informationSource === 'direct'">
          Now, it is time to make a decision.
<br><br>
While navigating the challenges of life on Xelifan-3, a breakthrough occurs. A member of your supporting science team, stationed at a remote research facility, shares an urgent discovery. Here is <strong>what the science team messaged to you</strong>:
<br><br>
<strong>The presence of Xeliherb is associatied with another plant called Ralocrop.</strong>
<br><br>
<strong>Question:</strong> How likely are you to cultivate additional Ralocrop?
          <SliderInput
            left="very unlikely"
            right="very likely"
            :response.sync= "$magpie.measurements.probs" />
            {{$magpie.measurements.probs}}%
            <button v-if="$magpie.measurements.probs" @click="$magpie.saveAndNextScreen();">Submit</button>
          <Record
            :data="{
              trialNR: i,
              itemNr: trial.itemNr,
              itemName: trial.itemName,
              condition: trial.condition,
              informationSource: trial.F1_informationSource,
              listenerRole: trial.F2_listenerRole,
              attentionCheckResult: $magpie.measurements.attentionCheck === correctAnswers[trial.F2_listenerRole]
            }"
          />
        </Slide> 
        <!-- ************************************ -->
      </Screen>
    </template>
    <PostTestScreen />

    <SubmitResultsScreen />
    
  </Experiment>
</template>

<script>

import items from '../trials/items.csv';
import _ from 'lodash';

var listenerTyp = _.sample(["colonist","scientist"])
var source = _.sample(["direct","indirect"])

console.log("Hi, I'm Pilot 04! I currently live in root. Excited to go live!");

export default {
  name: 'App',
  data() {
    //return { items: _.shuffle(items).slice(0, 1) };
    //return { items: items.slice(0, 1) };
    return { //items: items,
      items: _.shuffle(items).slice(0, 1),
    listenerTyp: listenerTyp,
    selectedTrial: null,
    source: source,
    correctAnswers: {
        colonist:'Ensure that there is a steady supply of Xeliherb to meet daily survival needs',
        scientist: 'Gather data to uncover patterns in Xeliherb growth that could inform future research'
      },
      showFeedback: false,
      feedbackMessage: '',
      feedbackColor: 'red'};
  },
  computed: {
    // Expose lodash to template code
    _() {
      return _;
    }
  },
  methods: {
    getPreviousResponse: function () {
      return this.$magpie.trialData[1][0].response;
    },
    selectTrial(trial) {
    this.selectedTrial = trial;
    this.validateResponse();
  },
  }
};


</script>
