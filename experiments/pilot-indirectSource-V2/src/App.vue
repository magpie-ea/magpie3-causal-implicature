<template>
  <Experiment title="Decision-making experiment"
  :image-assets="pictures">
    <InstructionScreen :title="'Welcome'">
      In this short experiment you will first read a description about a
      fictitious context in which you are supposed to make a decision based on
      some information you received from others. Please read the context
      information very carefully and make your decision deliberately.
      <p></p>
      After your choice, we will ask you to explain your choice in a few words.
    </InstructionScreen>

    <template v-for="(trial, i) of items">
    <!-- ************************************ -->
      <Screen label="background" title="Deep-Space Colonization">
    <div>
      <p>
        Far into the future, humankind has started to populate deep space.
        A powerful herb, called <strong>Xeliherb</strong>, has become <strong>vital for human survival</strong> and technological advancement.
        However, Xeliherb <strong>grows only sparsely</strong> on some far-out planets, making survival in deep space a constant struggle.
      </p>
      <!-- Add the image -->
      <img src="../pictures/background.png" alt="Background image" />
    </div>
    <!-- Next button -->
    <button @click="$magpie.nextScreen();">Next</button>
  </Screen>
  <!-- ************************************ -->
  <Screen label="earlydays" title="The Early Days">
    <div>
      <p>
        In the early days of deep space colonization, humans have relied on <strong>finding naturally growing Xeliherb</strong>.
        Dedicated <strong>Science Teams for Localization</strong> accumulated evidence for where to locate the precious, but fragile and hard-to-discover plant.
      </p>
      <!-- Add the image -->
      <img src="../pictures/earlydays.png" alt="earlydays image" />
    </div>
    <!-- Next button -->
    <button @click="$magpie.nextScreen();">Next</button>
  </Screen>
  <!-- ************************************ -->
  <Screen label="presentdays" title="The Present Times">
    <div>
      <p>
        While the discovery of naturally growing Xeliherb is still important, farmers have <strong>started successfully cultivating Xeliherb</strong> in controlled environments as well.
        Still, the herb proves difficult to cultivate, so that dedicated <strong>Science Teams for Cultivation</strong>  investigate how best to optimize the yield of Xeliherb farming.
      </p>
      <!-- Add the image -->
      <img src="../pictures/presentdays.png" alt="presentdays image" />
    </div>
    <!-- Next button -->
    <button @click="$magpie.nextScreen();">Next</button>
  </Screen>
  <!-- ************************************ -->
  <Screen label="yourrole" title="Your Role">
    <div>
      <p>
        You are leading a farming station for cultivating Xeliherb.
        Your job is to decide how best to maximize the yield of Xeliherb in the next farming cycle.
        You are currently thinking about experimenting with additionally cultivating a small amount of other deep-space herbs together with Xeliherb, such as <strong>Diaxone or Ralocrop</strong>.
        Presently, this is a total shot in the dark.
        You have no evidence so far that this might be effective.
        The problem is that <strong>cultivating Diaxone or Ralocrop is very costly</strong> in terms of precious resources and may even reduce the yield of Xeliherb.
      </p>
      <!-- Add the image -->
      <img src="../pictures/yourrole.png" alt="presentdays image" />
    </div>
    <!-- Next button -->
    <button @click="$magpie.nextScreen();">Next</button>
  </Screen>
  <!-- ************************************ -->
  <Screen :key="i" title="Check Your Knowledge">
  <Slide v-if="trial">
          <p>
              Two Science Teams are working on different objectives related to Xeliherb. Based on what you've read, what is the key objective of
              <strong> {{ trial.F1_informationSource === "indirect" ? "the Science Team for Localization" : "the Science Team for Cultivation" }} </strong>?
          </p>

          <MultipleChoiceInput
            :response.sync="$magpie.measurements.attentionCheck"
            :randomize="true"
            :options="[
              'Uncover the ecological impact of Xeliherb farming.', 
              'Understand the medical applications of Xeliherb.', 
              'Investigate where to find more naturally growing Xeliherb.', 
              'Find out how to improve the yield of cultivated Xeliherb.'
            ]" 
          />
          <button @click="$magpie.nextSlide();">Submit your answer.</button>
        </Slide>
    <Slide v-if="trial">
      <div v-if="$magpie.measurements.attentionCheck !== undefined">
              <p v-if="$magpie.measurements.attentionCheck === correctAnswers[trial.F1_informationSource]">
                Nice, correct answer! 
              </p>
              <p v-else>
                Wrong anwser. Please review your objectives again!
              </p>

              <button 
                v-if="$magpie.measurements.attentionCheck === correctAnswers[trial.F1_informationSource]" 
                @click="$magpie.nextScreen()">
                Next
              </button>
              
              <button 
                v-else 
                @click="$magpie.nextScreen('background')">
                Read again.
              </button>
            </div>
    </Slide>
  </Screen>
  <Screen :key="i" title="Your Preliminary Decision">
         <!-- ************************************ -->
         <Slide>
          Without any further information, and taking into account the fact that cultivation of additional herbs is costly in terms of resources, <strong>how likely is it that you would cultivate Ralocrop in addition to Xeliherb in the next farming cycle?</strong>
            <br><br>
          <SliderInput
            left="very unlikely"
            right="very likely"
            :response.sync= "$magpie.measurements.decision1" />
            {{$magpie.measurements.decision1}}%
            <button v-if="$magpie.measurements.decision1" @click="$magpie.saveAndNextScreen();">Submit</button>
            <Record
            :data="{
              trialNR: i,
              itemNr: trial.itemNr,
              itemName: trial.itemName,
              informationSource: trial.F1_informationSource,
              decision1: $magpie.measurements.decision1,
              decision2: $magpie.measurements.decision2
            }"
          />
        </Slide>
  </Screen>
  <!-- ************************************ -->
  <Screen :key="i" title="New Information">
           <!-- ************************************ -->
    <Slide v-if="trial.F1_informationSource === 'indirect'">
    <p>
    Coincidentally, you found an old journal from a <strong>Science Teams for Localization</strong> from the early days.
    Some scientists interested in localizing Xeliherb took the following note for themselves: <br>
    <strong> A high volume of Xeliherb is associated with the presence of Ralocrop. </strong>
    </p>
    <!-- Add the image -->
    <img src="../pictures/infoindirect.png" alt="infoindirect image" />
    <button @click="$magpie.nextScreen();">Next</button>
  </Slide>
         <!-- ************************************ -->
               <!-- ************************************ -->
    <Slide v-if="trial.F1_informationSource === 'direct'">
    <p>
    You received a recent report from a <strong>Science Teams for Cultivation</strong> who made a very interesting discovery.
    The report states: <br>
    <strong> A high volume of Xeliherb is associated with the presence of Ralocrop. </strong>
    </p>
    <img src="../pictures/infodirect.png" alt="infodirect image" />
    <button @click="$magpie.nextScreen();">Next</button>
  </Slide>
  </Screen>
  <!-- ************************************ -->
  <Screen :key="i" title="Your Final Decision">
         <!-- ************************************ -->
         <Slide>
          Now that you have additional information from the
          <strong> {{ trial.F1_informationSource === "indirect" ? "journal entry from the Science Team for Localization" : "report from the Science Team for Cultivation" }} </strong> which stated that:
            <br><br>
            <strong>"A high volume of Xeliherb is associated with the presence of Ralocrop."</strong>
            <br><br>
            how likely are you to cultivate Ralocrop in addition to Xeliherb in the next cycle?
          <SliderInput
            left="very unlikely"
            right="very likely"
            :response.sync= "$magpie.measurements.decision2" 
            />
            {{$magpie.measurements.decision2}}%
            <button v-if="$magpie.measurements.decision2" @click="$magpie.saveAndNextScreen();">Submit</button>
          <Record
            :data="{
              trialNR: i,
              itemNr: trial.itemNr,
              itemName: trial.itemName,
              informationSource: trial.F1_informationSource,
              decision1: $magpie.measurements.decision1,
              decision2: $magpie.measurements.decision2
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

import { Screen } from 'magpie-base';
import items from '../trials/items.csv';
import _ from 'lodash';

console.log("Hi, I'm Pilot 04! I currently live in root. Excited to go live!");

export default {
  name: 'App',
  data() {
    //return { items: _.shuffle(items).slice(0, 1) };
    //return { items: items.slice(0, 1) };
    return { //items: items,
      items: _.shuffle(items).slice(0, 1),
    selectedTrial: null,
    correctAnswers: {
        indirect:'Investigate where to find more naturally growing Xeliherb.',
        direct: 'Find out how to improve the yield of cultivated Xeliherb.'
      },
      showFeedback: false,
      feedbackMessage: '',
      feedbackColor: 'red',
      pictures: this.importAll(require.context('../pictures', false, /\.(png|jpe?g|svg)$/))};
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
    importAll(r) {
      return r.keys().map(r);
    },
    selectTrial(trial) {
    this.selectedTrial = trial;
    this.validateResponse();
  },
  }
};


</script>
