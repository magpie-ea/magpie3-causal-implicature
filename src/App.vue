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

    <template v-for="(trial, i) of items">
      <Screen :key="i">
        <Slide>
          <p><strong>Context:</strong> {{ trial.context }}</p>
          <p>
            <strong>{{ trial.criticalSentence }}</strong>
          </p>
          <p>
            {{ trial.furtherContext }}
          </p>
          <p><strong>Question:</strong> {{ trial.taskQuestion }}</p>
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
            {{ getPreviousResponse() }}!
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
          <p>
            There is also an outpost of your colonists on Xelifan-3.
            Unfortunately, due to atmospheric conditions, communication is difficult.
            You can only send a short message to the colonists in this outpost before all contact breaks off for potentially a long time.

            <strong>Tell the colonists all they need to know about xeliherb and ralocrop!</strong>

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

console.log("Hi, I'm Pilot 04! I currently live in root.")

export default {
  name: 'App',
  data() {
    //return { items: _.shuffle(items).slice(0, 1) };
    return { items: items.slice(0, 1) };
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
    }
  }
};
</script>
