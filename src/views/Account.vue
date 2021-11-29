<template lang="html">
  <div class="home" v-if="!account">
    <form @submit.prevent="signUp">
      <card
        title="Enter your username here"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <input
          type="text"
          class="input-username"
          v-model="username"
          placeholder="Type your username here"
        />
      </card>
    </form>
  </div>
  <div class="home" v-if="account">
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} ETH\t\t \nYour balance: ${account.balance} Tokens\t\t \nYour address: ${address}`"
        :gradient="true"
      >

        <div class="explanations">
          <button class="simple-button" @click="addTokens">ADD 200 TOKENS</button>
        </div>
        <div class="explanations">
          YOUR PROJECTS: {{ account.balance }} projects. </div>
        <div class="explanations">
          YOUR ENTERPRISES: {{ account.balance }} enterprises. </div>
      </card>
      <card
          title="Create a project"
          subtitle="Create a new project with tokens balance and contributors"
          :gradient="true"
      >
        <div v-if="!projectCreationTrigger" @click="toggleProjectCreation" style="cursor: pointer; margin: 25px 5px 20px 20px" >Click to add a new project to your account</div>
        <div v-if="projectCreationTrigger">
          <input
              type="text"
              v-model="projectName"
              class="input-username"
              placeholder="Name of the project"
          />
          <input
              type="number"
              v-model="projectTokensBalance"
              class="input-username"
              placeholder="Tokens balance"
          />
          <input
              type="text"
              v-model="projectContributorsList"
              class="input-username"
              placeholder="Contributors separated by comma"
          />
          <button class="simple-button" @click="createProject()"> SUBMIT !</button>
        </div>

      </card>
      <card
          title="Create an enterprise"
          subtitle="Create a new enterprise with tokens balance and contributors"
          :gradient="true"
      >
        <div v-if="!enterpriseCreationTrigger" @click="toggleEnterpriseCreation" style="cursor: pointer; margin: 25px 5px 20px 20px">Click to add a new enterprise</div>
        <div v-if="enterpriseCreationTrigger">
          <input
              type="text"
              v-model="enterpriseName"
              class="input-username"
              placeholder="Name of the enterprise"
          />
          <input
              type="number"
              v-model="enterpriseTokensBalance"
              class="input-username"
              placeholder="Tokens balance"
          />
          <input
              type="text"
              v-model="enterpriseContributorsList"
              class="input-username"
              placeholder="Contributors separated by comma"
          />

          <button class="simple-button" @click="createEnterpriseAccount()"> SUBMIT !</button>
        </div>
      </card>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const username = ''
    const project = null
    let projectName = null
    let enterpriseName = null
    return { account, username, project, projectName, enterpriseName, projectCreationTrigger:false, enterpriseCreationTrigger: false }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.getUser(address).call()
    },
    async signUp() {
      const { contract, username } = this
      const name = username.trim().replace(/ /g, '_')
      await contract.methods.signUp(name).send()
      await this.updateAccount()
      this.username = ''
    },
    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
    toggleProjectCreation() {
      this.projectCreationTrigger = !this.projectCreationTrigger;
    },
    toggleEnterpriseCreation() {
      this.enterpriseCreationTrigger = !this.enterpriseCreationTrigger;
    },
    async createProject() {
      const { contract, project } = this
      await contract.methods.createProject(this.projectName, 1).send()
      await this.updateAccount()
      this.projectCreationTrigger = false;
    },
    async createEnterpriseAccount() {
      const { contract } = this
      await contract.methods.createEnterpriseAccount(this.enterpriseName).send()
      await this.updateAccount()
      this.enterpriseCreationTrigger = false;
    }
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
  },
})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}

.explanations {
  padding: 12px;
}

.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.simple-button{
  margin: 25px 5px 20px 20px;

}
.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
</style>
