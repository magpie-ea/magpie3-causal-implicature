<template>
<Experiment title="magpie demo">
  <!-- <InstructionScreen :title="'Welcome'"> -->
  <!--   This is a sample introduction screen. -->
  <!-- </InstructionScreen> -->

  <template v-for="(trial, i) of items">
    <Screen>

      <Slide>
        <p><strong>Context:</strong> {{trial.context}}</p>
        <p><strong>{{trial.criticalSentence}}</strong></p>
        <p><strong>Question:</strong> {{trial.taskQuestion}}</p>
        <ForcedChoiceInput
          :response.sync= "$magpie.measurements.response"
          :options="['both xeliherb and ralocrop', 'bnly xeliherb']"
          @update:response="$magpie.saveAndNextScreen();"
          />
        <Record :data="{
                       itemNr : trial.itemNr,
                       itemName : trial.itemName,
                       condition : trial.condition
            }" />

      </Slide>

    </Screen>

    <Screen>

      <Slide>
        <p>Please give a short explanation for why you chose to cultivate {{getPreviousResponse()}}!</p>
        <p style="color:grey">(You need to enter at least 20 characters of text to proceed.)</p>
        <TextareaInput
            :response.sync= "$magpie.measurements.justification"
          />
        <button v-if= "$magpie.measurements.justification && $magpie.measurements.justification.length > 20" @click="$magpie.saveAndNextScreen();">Submit</button>
        <Record :data="{
                       itemNr : trial.itemNr,
                       itemName : trial.itemName,
                       condition : trial.condition
            }" />
      </Slide>
    </Screen>

  </template>
  <SubmitResultsScreen />
  </Experiment>
</template>

<script>

import items from '../trials/items.csv';
import _ from 'lodash';

export default {
  name: 'App',
  data() {
    return {items: _.shuffle(items).slice(0,1)};
  },
  computed: {
    // Expose lodash to template code
    _() {
      return _;
    }
  },
  methods: {
    getPreviousResponse : function() {
      return(this.$magpie.trialData[0][0].response)
    }
  }
};
</script>
