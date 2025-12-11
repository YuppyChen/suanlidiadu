import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/scheduling-policy',
      name: 'scheduling-policy',
      component: () => import('../views/SchedulingPolicyView.vue')
    },
    {
      path: '/resource-pool',
      name: 'resource-pool',
      component: () => import('../views/ResourcePoolView.vue')
    },
    {
      path: '/compute-node',
      name: 'compute-node',
      component: () => import('../views/ComputeNodeView.vue')
    }
  ]
})

export default router
