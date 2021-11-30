<template lang="html">
  <div class="home" v-if="!account && !showProjects">
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
  <div class="home" v-if="account && !showProjects && !showEnterprises">
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} ETH\t\t \nYour balance: ${account.balance} Tokens\t\t \nYour address: ${address}`"
        :gradient="true"
      >
        <div class="explanations">
          <button class="simple-button" @click="addTokens">
            ADD 200 TOKENS
          </button>
        </div>
        <div
          class="explanations"
          @click="toggleShowProjects()"
          style="cursor: pointer"
        >
          Click here to see the list of projects YOUR PROJECTS:
          {{ projects.length }} projects.
        </div>
        <div
          class="explanations"
          @click="toggleShowEnterprises()"
          style="cursor: pointer"
        >
          Click here to see your enterprises. YOUR ENTERPRISES:
          {{ enterprises.length }} enterprises.
        </div>
      </card>
      <card
        class="create-card"
        title="Create a project"
        subtitle="Create a new project with tokens balance and contributors"
        :gradient="true"
      >
        <div
          v-if="!projectCreationTrigger"
          @click="toggleProjectCreation"
          style="cursor: pointer; margin: 25px 5px 20px 20px"
        >
          Click to add a new project to your account
        </div>
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
          <button class="simple-button" @click="createProject()">
            SUBMIT !
          </button>
        </div>
      </card>
      <card
        class="create-card"
        title="Create an enterprise"
        subtitle="Create a new enterprise with tokens balance and contributors"
        :gradient="true"
      >
        <div
          v-if="!enterpriseCreationTrigger"
          @click="toggleEnterpriseCreation"
          style="cursor: pointer; margin: 25px 5px 20px 20px"
        >
          Click to add a new enterprise
        </div>
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

          <button class="simple-button" @click="createEnterpriseAccount()">
            SUBMIT !
          </button>
        </div>
      </card>
    </div>
  </div>
  <div class="home" v-if="account && showProjects">
    <div class="card-home-wrapper">
      <card
        :title="`Your username: ${account.username}`"
        subtitle="Projects list: (your projects are highlighted in red):"
        :gradient="true"
      >
        <button class="simple-button" @click="toggleShowProjects()">
          BACK
        </button>

        <div v-for="project in this.projects" v-bind:key="project.name">
          <card
            :title="`Project name: ${project.name}`"
            :subtitle="`Owner of the project: ${project.owner.username}`"
            v-bind:style="
              project.owner.username == account.username
                ? 'border: 10px solid red;'
                : 'border: none;'
            "
          />
        </div>
      </card>
    </div>
  </div>
  <div class="home" v-if="account && showEnterprises">
    <div class="card-home-wrapper">
      <card
        :title="`Your username: ${account.username}`"
        subtitle="Enterprises list:"
        :gradient="true"
      >
        <button class="simple-button" @click="toggleShowEnterprises()">
          BACK
        </button>

        <div
          v-for="enterprise in this.enterprises"
          v-bind:key="enterprise.name"
        >
          <card
            :title="`Enterprise name: ${enterprise.name}`"
            :subtitle="`Balance: ${enterprise.balance}`"
          />
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
    const projects: any[] = []
    const enterprises: any[] = []
    return {
      account,
      username,
      project,
      projectName,
      enterpriseName,
      projects,
      enterprises,
      projectCreationTrigger: false,
      enterpriseCreationTrigger: false,
      showProjects: false,
      showEnterprises: false,
    }
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
      this.projectCreationTrigger = !this.projectCreationTrigger
    },
    toggleEnterpriseCreation() {
      this.enterpriseCreationTrigger = !this.enterpriseCreationTrigger
    },
    async toggleShowProjects() {
      await this.getProjects()
      this.showProjects = !this.showProjects
    },
    async getProjects() {
      this.projects = []
      const { contract } = this
      const projects = await contract.methods.getProjects().call()
      if (projects.length > 0) {
        for (const project of projects) {
          let name = project.name
          let balance = project.balance
          let owner = project.owner
          this.projects.push({
            id: project.id,
            name: name,
            balance: balance,
            owner: owner,
          })
        }
      }
    },
    async toggleShowEnterprises() {
      await this.getUserEnterpriseIds()
      this.showEnterprises = !this.showEnterprises
    },
    async getUserEnterpriseIds() {
      this.enterprises = []
      const { contract } = this
      const enterprisesIds = await contract.methods
        .getUserEnterpriseIds()
        .call()
      if (enterprisesIds.length > 0) {
        for (const enterprisesId of enterprisesIds) {
          const enterprise = await contract.methods
            .getEnterprise(enterprisesId)
            .call()
          let name = enterprise.name
          let balance = enterprise.balance
          let owner = enterprise.owner
          this.enterprises.push({
            id: enterprise.id,
            name: name,
            balance: balance,
            owner: owner,
          })
        }
      }
    },
    // filterProjects() {
    //   const account = this
    //   return this.projects.filter(project => project.owner.username === account.username)
    // },
    async createProject() {
      const { contract, project } = this
      await contract.methods.createProject(this.projectName, 1).send()
      await this.updateAccount()
      this.projectCreationTrigger = false
      await this.getProjects()
    },
    async createEnterpriseAccount() {
      const { contract } = this
      await contract.methods.createEnterpriseAccount(this.enterpriseName).send()
      await this.updateAccount()
      this.enterpriseCreationTrigger = false
    },
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
  max-width: 1000px;
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

.simple-button {
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
