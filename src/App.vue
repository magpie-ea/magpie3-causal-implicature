<template>
<Experiment title="Decision-making experiment">
  <InstructionScreen :title="'Welcome'">
    In this short experiment you will first read a description about a
    fictitious context in which you are supposed to make an decision based on
    some information you received from others. Please read the context
    information very carefully and make your decision deliberately.
    <p></p>
    After your choice, we will ask you to explain your choice in a few words.
  </InstructionScreen>

    <ConnectInteractiveScreen :title="'Connecting...'"></ConnectInteractiveScreen>
    <AwaitIteratedResultScreen :title="'Waiting for previous participant to finish'">
    </AwaitIteratedResultScreen>
    <Wait :time="0" @done="prepareData();$magpie.nextScreen()" />

  <template v-for="(trial, i) of items">
    <Screen :key="i">
      <Slide>
        <h2><strong>Context</strong></h2>

        <p>You are leading a group of colonists to a far away planet called Xelifan-3. The information you received from Mission Control when you departed months ago is this:</p>

        <div style="background-color:#FF9999"><strong>Information from Mission Control:</strong> <br> Two plants grow exclusively on Xelifan-3. They are called xeliherb and ralocrop. To survive on Xelifan-3, you need constant supply of the seeds of xeliherb. The cultivation of ralocrop is costly (water, energy resources).</div>

          <p>On arrival to Xelifan-3 you find a message left by earlier colonists. Here is what the message says:</p>

          <div style="background-color:#AAAAFF">
            <strong>Message from earlier colonists:</strong>
            <br>
            {{ getPreviousResponse() }}
          </div>

          <p><strong>Question:</strong> Based on the information provided by Mission Control and the earlier colonists, will you cultivate both xeliherb and ralocrop on the fields available to your colony, or will you only cultivate xeliherb?</p>
          <ForcedChoiceInput
            :response.sync="$magpie.measurements.response"
            :options="['both xeliherb and ralocrop', 'only xeliherb']"
            @update:response="$magpie.saveAndNextScreen()"
          />
          <Record
            :data="{
              trialNR: i,
              itemNr: trial.itemNr,
              itemName: trial.itemName,
              condition: trial.condition,
              measure: 'choice'
            }"
          />
        </Slide>
      </Screen>

      <Screen :key="i">
        <Slide>
          <p>
            Please give a short explanation for why you chose to cultivate
            {{ getChoice() }}!
          </p>
          <!-- <p style="color: grey"> -->
          <!--   (You need to enter at least 20 characters of text to proceed.) -->
          <!-- </p> -->
          <TextareaInput :response.sync="$magpie.measurements.response" />
          <button
            v-if="
              $magpie.measurements.response
            "
            @click="$magpie.saveAndNextScreen()"
          >
            Submit
          </button>
          <Record
            :data="{
                   trialNR: i+1,
                   itemNr: trial.itemNr,
                   itemName: trial.itemName,
                   condition: trial.condition,
                   measure: 'justification'
            }"
          />
        </Slide>
      </Screen>

      <Screen :key="i">
        <Slide>
          <h2><strong>Oh, no! Abort mission immediately!</strong></h2>
          <p>
            Due to atmospheric conditions and technical problems you are forced to leave Xelifan-3 in a rush.
            You should make sure that the information you received from the earlier colonists is not lost to whoever may come next.
            <strong>Please write down what you recall from the earlier colonists' message into the text box!</strong>
          </p>
          <!-- <p style="color: grey"> -->
          <!--   (You need to enter at least 20 characters of text to proceed.) -->
          <!-- </p> -->
          <TextareaInput :response.sync="$magpie.measurements.response" />

          <p>
          For clarity, you do NOT have to repeat the information received from Mission Control, which is repeated below for your convenience.
          Only reproduce the message you received from the earlier colonists.
          </p>

        <div style="background-color:#FF9999"><strong>Information from Mission Control:</strong> <br> Two plants grow exclusively on Xelifan-3. They are called xeliherb and ralocrop. To survive on Xelifan-3, you need constant supply of the seeds of xeliherb. The cultivation of ralocrop is costly (water, energy resources).</div>

          <button
            v-if="
              $magpie.measurements.response
            "
            @click="$magpie.saveAndNextScreen()"
          >
            Submit
          </button>

          <Record
            :data="{
                   trialNR: i+2,
                   itemNr: trial.itemNr,
                   itemName: trial.itemName,
                   condition: trial.condition,
                   measure: 'reproduction'
            }"
          />
        </Slide>
      </Screen>
    </template>

    <PostTestScreen />

    <SubmitResultsScreen />

  </Experiment>
</template>

<script>
import items from '../trials/items.csv';
import _ from 'lodash';

console.log("Hi, I'm Pilot 02b, now living in root!")

export default {
  name: 'App',
  data() {
    // return { items: _.shuffle(items).slice(0, 1) };
    return { items: items.slice(0, 1) };
  },
  computed: {
    // Expose lodash to template code
    _() {
      return _;
    }
  },
  methods: {
    getChoice: function () {
      // we need index 4 here because this is the 4th trial in the experiment overall!?
      var output = this.$magpie.trialData[4] == null? null : this.$magpie.trialData[4][0].response;
      return (output);

    },
    prepareData: function(){
      console.log("variant: ", this.$magpie.socket.variant)
      console.log("chain: ", this.$magpie.socket.chain)
      console.log("generation: ", this.$magpie.socket.generation)
      var variant = this.$magpie.socket.variant
      this.guessingTrials = _.shuffle(_.filter(this.guessingTrials, {'variant' : variant}))
    },
    getPreviousResponse: function(){

      // which generation is this
      var generation = this.$magpie.socket.generation;

      var output = "A high yield of xeliherb is associated with the presence of ralocrop."

      console.log("local generation", generation);

      // if we are in the first generation, we will return the defaultGuess for the item
      if (generation > 1) {
        console.log("Generation > 1, check")

         // get information about the results from the last iteration from the socket
         var lastIterationResults = this.$magpie.socket.lastIterationResults;

         // before initialization with ConnectInteractiveScreen, lastIterationResults will be 'null'
         // so we make sure that there is some output
         // if we are neither first-generation in the chain, nor have an empty socket,
         // we can return the previous input for the current item

         var filteredData = _.filter(lastIterationResults, function(o) {return o.measure == 'reproduction'})
         var extractedRow = filteredData[0]
         console.log(filteredData)
         console.log(extractedRow)
         output = extractedRow == null ? null : extractedRow.response
      }

      return( output )
    }
  }
};
</script>
