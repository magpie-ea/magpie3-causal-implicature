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
      <Screen label="background">
    <div>
      <p>
        <strong>Background:</strong> Far into the future, humankind is starting to populate deep space. <br>
        A powerful herb, called <strong>Xeliherb</strong>, has become vital for human survival and technological advancement. <br>
        However, <strong>Xeliherb</strong> grows only sparsely on some far-out planets, making survival in deep space a constant struggle.
      </p>
      <!-- Add the image -->
      <img src="../pictures/background.png" alt="Background image" />
    </div>
    <!-- Next button -->
    <button @click="$magpie.nextScreen();">Next</button>
  </Screen>
  <!-- ************************************ -->
  <Screen label="earlydays">
    <div>
      <p>
        <strong>Early days:</strong> In the early days of deep space colonization, humans have relied on finding naturally growing <strong>Xeliherb</strong>.
        Dedicated <strong>Science Teams for Localization</strong> accumulated evidence for where to locate the precious, but fragile and hard-to-discover plant.
      </p>
      <!-- Add the image -->
      <img src="../pictures/earlydays.png" alt="earlydays image" />
    </div>
    <!-- Next button -->
    <button @click="$magpie.nextScreen();">Next</button>
  </Screen>
  <!-- ************************************ -->
  <Screen label="presentdays">
    <div>
      <p>
        <strong>Present days:</strong> While the discovery of naturally growing <strong>Xeliherb</strong> is still important, farmers have started successfully cultivating <strong>Xeliherb</strong> in controlled environments as well. 
        Still, the herb proves difficult to cultivate, so that dedicated <strong>Science Teams for Cultivation</strong>  investigate the causal factors influencing the yield of <strong>Xeliherb</strong> farming. 
      </p>
      <!-- Add the image -->
      <img src="../pictures/presentdays.png" alt="presentdays image" />
    </div>
    <!-- Next button -->
    <button @click="$magpie.nextScreen();">Next</button>
  </Screen>
  <!-- ************************************ -->
  <Screen label="yourrole">
    <div>
      <p>
        <strong>Your role:</strong> You are leading a farming station for cultivating Xeliherb. 
        Your job is to decide how best to maximize the yield in the next farming cycle. 
      </p>
      <!-- Add the image -->
      <img src="../pictures/yourrole.png" alt="presentdays image" />
    </div>
    <!-- Next button -->
    <button @click="$magpie.nextScreen();">Next</button>
  </Screen>
  <!-- ************************************ -->
  <Screen :key="i">
  <Slide v-if="trial">
          <p>
            <strong>
              Two science teams are working on different objectives related to Xeliherb. Based on what you've read, what is the key objective of 
              <strong> {{ trial.F1_informationSource === "indirect" ? "the Science Team for Localization" : "the Science Team for Cultivation" }} </strong>? 
              (Please select one correct answer)
            </strong>
          </p>

          <MultipleChoiceInput
            :response.sync="$magpie.measurements.attentionCheck"
            :randomize="true"
            :options="[
              'Focuses on the ecological impact of Xeliherb farming.', 
              'Focuses on medical applications of Xeliherb.', 
              'Investigates where naturally growing Xeliherb can be found.', 
              'Studies how to improve the yield of cultivated Xeliherb.'
            ]" 
          />
          <div v-if="$magpie.measurements.attentionCheck !== undefined">
            <p v-if="$magpie.measurements.attentionCheck === correctAnswers[trial.F1_informationSource]">
              Correct answer! 
            </p>
            <p v-else>
              Please review your objectives again!
            </p>

            <button 
              v-if="$magpie.measurements.attentionCheck === correctAnswers[trial.F1_informationSource]" 
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
           <!-- ************************************ -->
    <Slide v-if="trial.F1_informationSource === 'indirect'">
    <p>
    <strong>Your information:</strong> You found an old precious journal from a <strong>Science Teams for Localization</strong> from the early days who made a very interesting discovery. 
    The journal states: <br>
    <strong> A high volume of Xeliherb is associated with the presence of Ralocrop. </strong>
    </p>
    <!-- Add the image -->
    <img src="../pictures/infoindirect.png" alt="infoindirect image" />
    <button @click="$magpie.nextSlide();">Next</button>
  </Slide>
         <!-- ************************************ -->
               <!-- ************************************ -->
    <Slide v-if="trial.F1_informationSource === 'direct'">
    <p>
    <strong>Your information:</strong> You received a recent report from a <strong>Science Teams for Cultivation</strong> who made a very interesting discovery.  
    The report states: <br>
    <strong> A high volume of Xeliherb is associated with the presence of Ralocrop. </strong>
    </p>
    <!-- Add the image -->
    <img src="../pictures/infodirect.png" alt="infodirect image" />
    <button @click="$magpie.nextSlide();">Next</button>
  </Slide>
         <!-- ************************************ -->
         <Slide>
          <strong>Your decision:</strong> Based on the
          <strong> {{ trial.F1_informationSource === "indirect" ? "journal entry from the Science Team for Localization" : "report from the Science Team for Cultivation" }} </strong> which stated that:
            <br><br>
            <strong>"A high volume of Xeliherb is associated with the presence of Ralocrop."</strong>
            <br><br>
            <strong>Question:</strong> How likely are you to cultivate additional Ralocrop?
            <br>
            Notice that Ralocrop is another herb, which is expensive to cultivate in addition to Xeliherb.
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
              informationSource: trial.F1_informationSource,
              attentionCheckResult: $magpie.measurements.attentionCheck === correctAnswers[trial.F1_informationSource]
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
        indirect:'Investigates where naturally growing Xeliherb can be found.',
        direct: 'Studies how to improve the yield of cultivated Xeliherb.'
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
