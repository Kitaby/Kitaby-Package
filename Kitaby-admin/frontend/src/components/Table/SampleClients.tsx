import { mdiEye, mdiTrashCan } from '@mdi/js'
import React, { useEffect, useState } from 'react'
import { useSampleClients } from '../../hooks/sampleData'
import { User } from '../../interfaces'
import Button from '../Button'
import Buttons from '../Buttons'
import CardBoxModal from '../CardBox/Modal'

const TableSampleClients = () => {
  const [clients, setClients] = useState<User[]>([])
  const [selectedUser, setSelectedUser] = useState(null)

  const fetchData = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/admin/getusers', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })

      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()
      setClients(data)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }

  useEffect(() => {
    fetchData() 
  }, [])

  const perPage = 5
  const [currentPage, setCurrentPage] = useState(0)
  const clientsPaginated = clients.slice(perPage * currentPage, perPage * (currentPage + 1))
  const numPages = Math.floor(clients.length / perPage)+1
  const pagesList = []
  for (let i = 0; i < numPages; i++) {
    pagesList.push(i)
  }

  const [isModalUpdateActive, setIsModalUpdateActive] = useState(false)
  const [isModalTrashActive, setIsModalTrashActive] = useState(false)

  const handleUpdateAction = () => {
    setIsModalUpdateActive(false)
  }

  const handleBanAction = (id: string) => {
    setIsModalTrashActive(true)
    setSelectedUser(id)
  }
  const handleCancelAction = () => {
    setIsModalTrashActive(false)
  }

  const confirmBanAction = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/admin/banuser/${selectedUser}`, {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      })

      if (!response.ok) {
        throw new Error('Failed to fetch data')
      }

      const data = await response.json()
      setClients(data)
      setIsModalTrashActive(false)
    } catch (error) {
      console.error('Error fetching data:', error)
    }
  }

  return (
    <>
      <CardBoxModal
        title="Please confirm"
        buttonColor="danger"
        buttonLabel="Confirm"
        isActive={isModalTrashActive}
        onConfirm={confirmBanAction}
        onCancel={handleCancelAction}
      >
        <p>Are you sure you want to ban this user?</p>
      </CardBoxModal>

      <table>
        <thead>
          <tr>
            <th></th>
            <th>Username</th>
            <th>Email</th>
            <th>Phone Number</th>
            <th>Wilaya</th>
            <th />
          </tr>
        </thead>
        <tbody>
          {clientsPaginated.map((client: User, index) => (
            <tr key={client.id}>
              <td className="border-b-0 lg:w-6 before:hidden">{index + 1}</td>
              <td data-label="Name">{client.name}</td>
              <td data-label="Email">{client.email}</td>
              <td data-label="Created" className="lg:w-1 whitespace-nowrap">
                <small className="text-gray-500 dark:text-slate-400">{client.phone}</small>
              </td>
              <td data-label="Email">{client.wilaya}</td>
              <td className="before:hidden lg:w-1 whitespace-nowrap">
                <Buttons type="justify-start lg:justify-end" noWrap>
                  <Button
                    color="danger"
                    icon={mdiTrashCan}
                    onClick={() => handleBanAction(client._id)}
                    small
                  />
                </Buttons>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/*Pagination stuff */}
      <div className="p-3 lg:px-6 border-t border-gray-100 dark:border-slate-800">
        <div className="flex flex-col md:flex-row items-center justify-between py-3 md:py-0">
          <Buttons>
            {pagesList.map((page) => (
              <Button
                key={page}
                active={page === currentPage}
                label={page + 1}
                color={page === currentPage ? 'lightDark' : 'whiteDark'}
                small
                onClick={() => setCurrentPage(page)}
              />
            ))}
          </Buttons>
          <small className="mt-6 md:mt-0">
            Page {currentPage + 1} of {numPages}
          </small>
        </div>
      </div>
    </>
  )
}

export default TableSampleClients
