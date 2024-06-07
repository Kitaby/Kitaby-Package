import {
  mdiAccountMultiple,
  mdiCartOutline,
  mdiChartPie,
  mdiChartTimelineVariant,
  mdiGithub,
  mdiMonitorCellphone,
  mdiReload,
} from '@mdi/js'
import Head from 'next/head'
import React, { useState, useEffect } from 'react'
import type { ReactElement } from 'react'
import Button from '../components/Button'
import LayoutAuthenticated from '../layouts/Authenticated'
import SectionMain from '../components/Section/Main'
import SectionTitleLineWithButton from '../components/Section/TitleLineWithButton'
import CardBoxWidget from '../components/CardBox/Widget'
import { useSampleClients /* useSampleTransactions */ } from '../hooks/sampleData'
import CardBoxTransaction from '../components/CardBox/Transaction'
import { User, Transaction } from '../interfaces'
import CardBoxClient from '../components/CardBox/Client'
import SectionBannerStarOnGitHub from '../components/Section/Banner/StarOnGitHub'
import CardBox from '../components/CardBox'
import { sampleChartData } from '../components/ChartLineSample/config'
import ChartLineSample from '../components/ChartLineSample'
import NotificationBar from '../components/NotificationBar'
import TableSampleClients from '../components/Table/SampleClients'
import { getPageTitle } from '../config'
import { set } from 'mongoose'

const DashboardPage = () => {
  /* const { transactions } = useSampleTransactions() */
  const [clients, setClients] = useState<User[]>([])
  const [userNum, setUserNum] = useState(0)
  const [bookNum, setBookNum] = useState(0)

  const fetchUsers = async () => {
    try {
      const users = await fetch('http://localhost:3001/api/admin/getusers', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })

      if (!users.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await users.json()
      setClients(data)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }
  const fetchBooks = async () => {
    try {
      const books = await fetch('http://localhost:3000/api/admin/getbooks', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })

      if (!books.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await books.json()
      setClients(data)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }
  const fetchNumbers = async () => {
    try {
      const bookNum = await fetch('http://localhost:3000/api/admin/getbooknumbers', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })
      const userNum = await fetch('http://localhost:3000/api/admin/getusernumbers', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })

      const bookData = await bookNum.json()
      const userData = await userNum.json()
      setUserNum(userData)
      setBookNum(bookData)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }
  useEffect(() => {
    fetchNumbers()
    fetchBooks()
    fetchUsers()
    fetchGraphData()
  }, [])
  //const clientsListed = clients.slice(0, 4)
  const fetchGraphData = async () => {
    const responseReservations = await fetch('http://localhost:3000/api/admin/getreservationhistory')
    const dataReservation = await responseReservations.json()
    setChartDataReservations(dataReservation)

    const responseExchanges = await fetch('http://localhost:3000/api/admin/getexchangehistory')
    const dataExchanges = await responseExchanges.json()
    setChartDataExchanges(dataExchanges)

    const responseUsers = await fetch('http://localhost:3000/api/admin/getuserhistory')
    const dataUsers = await responseUsers.json()
    setChartDataUsers(dataUsers) // Step 3: Set the fetched data to the corresponding state variable

    const responseLibraries = await fetch('http://localhost:3000/api/admin/getbibhistory')
    const dataLibraries = await responseLibraries.json()
    setChartDataLibraries(dataLibraries) 
    return 
  }
  const [chartDataReservations, setChartDataReservations] = useState(null)
  const [chartDataExchanges, setChartDataExchanges] = useState(null)
  const [chartDataUsers, setChartDataUsers] = useState(null)
  const [chartDataLibraries, setChartDataLibraries] = useState(null)

  // Empty dependency array means this effect runs once on mount
  const fillChartData = (e: React.MouseEvent) => {
    e.preventDefault()
    setChartDataReservations(sampleChartData())
  }
  const chartColors = {
    default: {
      primary: '#00D1B2',
      info: '#209CEE',
      danger: '#FF3860',
    },
  }
  return (
    <>
      <Head>
        <title>{getPageTitle('Dashboard')}</title>
      </Head>
      <SectionMain>
        <SectionTitleLineWithButton icon={mdiChartTimelineVariant} title="Overview" main />

        {/*
          Modify from here !
        */}

        {/*the num of users */}
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-3 mb-6">
          <CardBoxWidget
            trendLabel="100%"
            trendType="up"
            trendColor="success"
            icon={mdiAccountMultiple}
            iconColor="success"
            number={userNum}
            label="Users"
          />
          {/*Exchanges */}
          <CardBoxWidget
            trendLabel="16%"
            trendType="up"
            trendColor="success"
            icon={mdiCartOutline}
            iconColor="info"
            number={bookNum}
            label="Exchanges"
          />
          {/*Library rents */}
          <CardBoxWidget
            trendLabel="18%"
            trendType="down"
            trendColor="danger"
            icon={mdiChartTimelineVariant}
            iconColor="danger"
            number={15}
            label="Reservations"
          />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
          {/* <div className="flex flex-col justify-between">
            {transactions.map((transaction: Transaction) => (
              <CardBoxTransaction key={transaction.id} transaction={transaction} />
            ))}
          </div>
          <div className="flex flex-col justify-between">
            {clientsListed.map((client: User) => (
              <CardBoxClient key={client.id} client={client} />
            ))}
          </div> */}
        </div>
        <SectionTitleLineWithButton icon={mdiAccountMultiple} title="Users and Libraries " />

        <CardBox className="mb-6">
          <ChartLineSample
            data={{
              labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
              datasets: [
                {
                  fill: false,
                  label: 'Users',
                  borderColor: chartColors.default["primary"],
                  borderWidth: 2,
                  borderDash: [],
                  borderDashOffset: 0.0,
                  pointBackgroundColor: chartColors.default["primary"],
                  pointBorderColor: 'rgba(255,255,255,0)',
                  pointHoverBackgroundColor: chartColors.default["primary"],
                  pointBorderWidth: 20,
                  pointHoverRadius: 4,
                  pointHoverBorderWidth: 15,
                  pointRadius: 4,
                  data:chartDataUsers,
                  tension: 0.5,
                  cubicInterpolationMode: 'default',
                },
                {
                  fill: false,
                  label: 'Libraries',
                  borderColor: chartColors.default["info"],
                  borderWidth: 2,
                  borderDash: [],
                  borderDashOffset: 0.0,
                  pointBackgroundColor: chartColors.default["info"],
                  pointBorderColor: 'rgba(255,255,255,0)',
                  pointHoverBackgroundColor: chartColors.default["info"],
                  pointBorderWidth: 20,
                  pointHoverRadius: 4,
                  pointHoverBorderWidth: 15,
                  pointRadius: 4,
                  data:chartDataLibraries,
                  tension: 0.5,
                  cubicInterpolationMode: 'default',
                },
              ],
            }}
          />
        </CardBox>

        <SectionTitleLineWithButton icon={mdiChartPie} title="Reservations and Exchanges overview">
          <Button icon={mdiReload} color="whiteDark" onClick={fillChartData} />
        </SectionTitleLineWithButton>

        <CardBox className="mb-6">
          <ChartLineSample
            data={{
              labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
              datasets: [
                {
                  fill: false,
                  label: 'Reservations',
                  borderColor: chartColors.default["primary"],
                  borderWidth: 2,
                  borderDash: [],
                  borderDashOffset: 0.0,
                  pointBackgroundColor: chartColors.default["primary"],
                  pointBorderColor: 'rgba(255,255,255,0)',
                  pointHoverBackgroundColor: chartColors.default["primary"],
                  pointBorderWidth: 20,
                  pointHoverRadius: 4,
                  pointHoverBorderWidth: 15,
                  pointRadius: 4,
                  data:chartDataReservations,
                  tension: 0.5,
                  cubicInterpolationMode: 'default',
                },
                {
                  fill: false,
                  label: 'Exchanges',
                  borderColor: chartColors.default["info"],
                  borderWidth: 2,
                  borderDash: [],
                  borderDashOffset: 0.0,
                  pointBackgroundColor: chartColors.default["info"],
                  pointBorderColor: 'rgba(255,255,255,0)',
                  pointHoverBackgroundColor: chartColors.default["info"],
                  pointBorderWidth: 20,
                  pointHoverRadius: 4,
                  pointHoverBorderWidth: 15,
                  pointRadius: 4,
                  data:chartDataExchanges,
                  tension: 0.5,
                  cubicInterpolationMode: 'default',
                },
              ],
            }}
          />
        </CardBox>
        

        
      </SectionMain>
    </>
  )
}

DashboardPage.getLayout = function getLayout(page: ReactElement) {
  return <LayoutAuthenticated>{page}</LayoutAuthenticated>
}

export default DashboardPage
